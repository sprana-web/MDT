import { NextResponse } from "next/server";
import ee from "@google/earthengine";

// Authenticate Google Earth Engine
async function initializeGEE() {
  return new Promise((resolve, reject) => {
    ee.data.authenticateViaPrivateKey(
      JSON.parse(process.env.GEE_PRIVATE_KEY),
      () => {
        console.log("✅ GEE Authentication Successful!");
        ee.initialize();
        resolve();
      },
      (error) => {
        console.error("❌ GEE Authentication Failed:", error);
        reject(error);
      },
    );
  });
}

export async function POST(req) {
  try {
    await initializeGEE();
    const { aoi, startDate, endDate } = await req.json();
    console.log("📡 Classifying Sentinel-2 Data from GEE...");

    if (!Array.isArray(aoi) || aoi.length < 3) {
      throw new Error(
        "User AOI must be an array of at least 3 coordinate points.",
      );
    }
    if (JSON.stringify(aoi[0]) !== JSON.stringify(aoi[aoi.length - 1])) {
      aoi.push(aoi[0]);
    }
    const userAOI = ee.Geometry.Polygon(aoi);

    const municipalBoundary = ee
      .FeatureCollection("projects/ee-spranatungano/assets/gjo_kom")
      .first()
      .geometry()
      .simplify({ maxError: 500 });

    const sentinelImage = ee
      .ImageCollection("COPERNICUS/S2_HARMONIZED")
      .filterDate(startDate, endDate)
      .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 20))
      .filterBounds(municipalBoundary)
      .median()
      .clip(municipalBoundary);

    const bands = ["B2", "B3", "B4", "B8"];

    let trainingFC = ee
      .FeatureCollection("projects/ee-spranatungano/assets/trainingData3")
      .filterBounds(municipalBoundary);
    const trainingCount = trainingFC.size().getInfo();
    if (trainingCount === 0) {
      throw new Error(
        "No valid training data found within the municipal area.",
      );
    }

    const trainingWithRandom = trainingFC.randomColumn("random");
    const trainingSampleFC = trainingWithRandom.filter(
      ee.Filter.lte("random", 0.75),
    );
    const trainingSamples = sentinelImage.select(bands).sampleRegions({
      collection: trainingSampleFC,
      properties: ["class"],
      scale: 10,
    });

    const classifier = ee.Classifier.smileRandomForest(10).train({
      features: trainingSamples,
      classProperty: "class",
      inputProperties: bands,
    });

    const sentinelImageAOI = sentinelImage.clip(userAOI);

    const classifiedAOI = sentinelImageAOI.select(bands).classify(classifier);

    // Match alluvial diagram logic: mask after classification
    // Simulate after mask with same image
    const classifiedTemp = sentinelImageAOI.select(bands).classify(classifier);

    const combinedMask = classifiedTemp.mask().and(classifiedTemp.mask()); // mimic and()
    const classifiedMasked = classifiedTemp.updateMask(combinedMask);

    const validationSampleFC = trainingWithRandom.filter(
      ee.Filter.gt("random", 0.75),
    );
    const validationSamples = sentinelImage.select(bands).sampleRegions({
      collection: validationSampleFC,
      properties: ["class"],
      scale: 10,
    });
    const validated = validationSamples.classify(classifier);

    const debugSample = await new Promise((resolve, reject) =>
      validated
        .first()
        .evaluate((val, err) => (err ? reject(err) : resolve(val))),
    );
    console.log("✅ Sample validated point:", debugSample);

    const errorMatrix = validated.errorMatrix("class", "classification");
    const [
      overallAccuracyInfo,
      kappaInfo,
      precisionInfo,
      recallInfo,
      classOrder,
    ] = await Promise.all([
      new Promise((resolve, reject) =>
        errorMatrix
          .accuracy()
          .evaluate((val, err) => (err ? reject(err) : resolve(val))),
      ),
      new Promise((resolve, reject) =>
        errorMatrix
          .kappa()
          .evaluate((val, err) => (err ? reject(err) : resolve(val))),
      ),
      new Promise((resolve, reject) =>
        errorMatrix
          .consumersAccuracy()
          .evaluate((val, err) => (err ? reject(err) : resolve(val))),
      ),
      new Promise((resolve, reject) =>
        errorMatrix
          .producersAccuracy()
          .evaluate((val, err) => (err ? reject(err) : resolve(val))),
      ),
      new Promise((resolve, reject) =>
        errorMatrix
          .order()
          .evaluate((val, err) => (err ? reject(err) : resolve(val))),
      ),
    ]);

    const precisionArray = Array.isArray(precisionInfo[0])
      ? precisionInfo[0]
      : precisionInfo;
    const recallArray = Array.isArray(recallInfo[0])
      ? recallInfo.map((r) => r[0])
      : recallInfo;

    const toRoundedNumber = (val) =>
      typeof val === "number" && !isNaN(val) ? parseFloat(val.toFixed(3)) : 0;

    const precisionRounded = precisionArray.map(toRoundedNumber);
    const recallRounded = recallArray.map(toRoundedNumber);
    const f1Rounded = precisionArray.map((p, i) => {
      const r = recallArray[i];
      if (typeof p !== "number" || typeof r !== "number" || p + r === 0)
        return 0;
      return parseFloat(((2 * p * r) / (p + r)).toFixed(3));
    });

    const visParams = {
      min: 0,
      max: 5,
      palette: ["blue", "gray", "green", "yellow", "orange", "red"],
    };
    const visImage = classifiedMasked.visualize(visParams).reproject({
      crs: sentinelImage.projection(),
      scale: 10,
    });

    const areaImage = ee.Image.pixelArea().divide(1e6); // in km²
    const areaStatsImage = areaImage.addBands(classifiedMasked);

    const areaStats = await new Promise((resolve, reject) => {
      areaStatsImage
        .reduceRegion({
          reducer: ee.Reducer.sum().group({
            groupField: 1,
            groupName: "class",
          }),
          geometry: userAOI,
          scale: 10,
          maxPixels: 1e9,
        })
        .evaluate((res, err) => (err ? reject(err) : resolve(res)));
    });

    const boundsInfo = userAOI.bounds().getInfo();
    const coords = boundsInfo.coordinates[0];
    const minLng = Math.min(...coords.map((c) => c[0]));
    const maxLng = Math.max(...coords.map((c) => c[0]));
    const minLat = Math.min(...coords.map((c) => c[1]));
    const maxLat = Math.max(...coords.map((c) => c[1]));
    const regionRect = {
      type: "Polygon",
      coordinates: [
        [
          [minLng, minLat],
          [maxLng, minLat],
          [maxLng, maxLat],
          [minLng, maxLat],
          [minLng, minLat],
        ],
      ],
    };

    const lonSpan = Math.abs(maxLng - minLng);
    const latSpan = Math.abs(maxLat - minLat);
    const meanLatRad = ((minLat + maxLat) / 2) * (Math.PI / 180);
    const widthRatio = lonSpan * Math.cos(meanLatRad);
    const heightRatio = latSpan;
    const aspectRatio = widthRatio > 0 ? heightRatio / widthRatio : 1;
    const maxDimension = 2048;
    const dimensions =
      aspectRatio >= 1
        ? [Math.max(1, Math.round(maxDimension / aspectRatio)), maxDimension]
        : [maxDimension, Math.max(1, Math.round(maxDimension * aspectRatio))];

    const mapId = visImage.getMapId({
      region: JSON.stringify(regionRect),
      dimensions: "600x600",
    });

    if (!mapId || !mapId.mapid) {
      throw new Error("Invalid mapId generated for classification.");
    }

    const dimensionString = `${dimensions[0]}x${dimensions[1]}`;
    const downloadUrl = visImage.getThumbURL({
      region: regionRect,
      dimensions: dimensionString,
      format: "png",
      crs: "EPSG:4326",
    });

    console.log("✅ Classification Tile Layer URL Generated:", mapId.urlFormat);
    console.log("✅ Classification Download URL Generated:", downloadUrl);
    console.log("Overall Accuracy:", overallAccuracyInfo.toFixed(3));

    return NextResponse.json({
      tileUrl: mapId.urlFormat,
      downloadUrl,
      accuracy: parseFloat(overallAccuracyInfo.toFixed(3)),
      kappa: parseFloat(kappaInfo.toFixed(3)),
      areaStats,
      precision: precisionRounded,
      recall: recallRounded,
      f1: f1Rounded,
      classLabels: ["Water", "Built-up", "Forest", "Crops", "Bare lands"],
    });
  } catch (error) {
    console.error("❌ Error in classification API:", error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
