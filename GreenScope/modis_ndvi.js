import { NextResponse } from "next/server";
import ee from "@google/earthengine";

async function initializeGEE() {
  return new Promise((resolve, reject) => {
    ee.data.authenticateViaPrivateKey(
      JSON.parse(process.env.GEE_PRIVATE_KEY),
      () => {
        ee.initialize();
        resolve();
      },
      (err) => reject(err)
    );
  });
}

export async function POST(req) {
  try {
    await initializeGEE();
    const { startDate, endDate } = await req.json();

    // Catchment geometry (Mjøsa)
    const vannomr_mjosa = ee.FeatureCollection(
      "projects/ee-spranatungano/assets/vannomr_mjosa"
    );
    const catchmentGeom = vannomr_mjosa.geometry();

    // MODIS Combined 16-Day NDVI (derived from MCD43A4 surface reflectance)
    // Band: 'NDVI' (range roughly -1 to 1), nominal scale 500 m.
    const ndviCollection = ee
      .ImageCollection("MODIS/MCD43A4_006_NDVI")
      .filterDate(startDate, endDate)
      .select("NDVI");

    // Mean NDVI over the period, clipped to catchment
    const ndviImage = ndviCollection.mean().clip(catchmentGeom);

    // Overall statistics (min, max, mean) over the catchment
    const ndviStats = ndviImage.reduceRegion({
      reducer: ee.Reducer.minMax().combine({
        reducer2: ee.Reducer.mean(),
        sharedInputs: true,
      }),
      geometry: catchmentGeom,
      scale: 500,
      maxPixels: 1e9,
    });

    const ndviStatsInfo = await new Promise((resolve, reject) => {
      ndviStats.getInfo((result, err) => {
        if (err) reject(err);
        else resolve(result);
      });
    });

    const ndviMin =
      ndviStatsInfo.NDVI_min !== null && ndviStatsInfo.NDVI_min !== undefined
        ? Math.round(ndviStatsInfo.NDVI_min * 1000) / 1000
        : null;
    const ndviMax =
      ndviStatsInfo.NDVI_max !== null && ndviStatsInfo.NDVI_max !== undefined
        ? Math.round(ndviStatsInfo.NDVI_max * 1000) / 1000
        : null;
    const ndviMean =
      ndviStatsInfo.NDVI_mean !== null && ndviStatsInfo.NDVI_mean !== undefined
        ? Math.round(ndviStatsInfo.NDVI_mean * 1000) / 1000
        : null;

    // Monthly means across the requested date range
    const start = ee.Date(startDate);
    const end = ee.Date(endDate);
    const monthsInRange = ee.List.sequence(
      0,
      end.difference(start, "month").subtract(1)
    ).map(function (i) {
      const d = start.advance(i, "month");
      return ee.Dictionary({ year: d.get("year"), month: d.get("month") });
    });

    const monthlyStats = monthsInRange.map(function (item) {
      const dict = ee.Dictionary(item);
      const year = ee.Number(dict.get("year"));
      const month = ee.Number(dict.get("month"));

      const monthlyCollection = ee
        .ImageCollection("MODIS/MCD43A4_006_NDVI")
        .filter(ee.Filter.calendarRange(year, year, "year"))
        .filter(ee.Filter.calendarRange(month, month, "month"))
        .select("NDVI");

      const count = monthlyCollection.size();

      const monthlyImg = ee.Image(
        ee.Algorithms.If(
          count.gt(0),
          monthlyCollection.mean().clip(catchmentGeom),
          ee.Image(0).rename("NDVI").clip(catchmentGeom)
        )
      );

      const meanNDVI = monthlyImg
        .reduceRegion({
          reducer: ee.Reducer.mean(),
          geometry: catchmentGeom,
          scale: 500,
          maxPixels: 1e9,
        })
        .get("NDVI");

      return ee.Dictionary({
        year: year,
        month: month,
        ndvi: meanNDVI,
        count: count,
      });
    });

    const monthlyStatsList = await monthlyStats.getInfo();

    // Visualization parameters for NDVI
    // Typical: focus on vegetation signal [0, 0.9], but include negatives for water/snow.
    const visParams = {
      min: 0,
      max: 1,
      palette: [
        "ffffff",
        "ce7e45",
        "df923d",
        "f1b555",
        "fcd163",
        "99b718",
        "74a901",
        "66a000",
        "529400",
        "3e8601",
        "207401",
        "056201",
        "004c00",
        "023b01",
        "012e01",
        "011d01",
        "011301",
      ],
    };

    const visImage = ndviImage.visualize(visParams).reproject({
      crs: ndviImage.projection(),
      scale: 500,
    });

    // Region bounds for tile
    const bounds = catchmentGeom.bounds().getInfo();
    const coords = bounds.coordinates[0];
    const regionRect = {
      type: "Polygon",
      coordinates: [
        [
          [
            Math.min(...coords.map((c) => c[0])),
            Math.min(...coords.map((c) => c[1])),
          ],
          [
            Math.max(...coords.map((c) => c[0])),
            Math.min(...coords.map((c) => c[1])),
          ],
          [
            Math.max(...coords.map((c) => c[0])),
            Math.max(...coords.map((c) => c[1])),
          ],
          [
            Math.min(...coords.map((c) => c[0])),
            Math.max(...coords.map((c) => c[1])),
          ],
          [
            Math.min(...coords.map((c) => c[0])),
            Math.min(...coords.map((c) => c[1])),
          ],
        ],
      ],
    };

    const mapId = visImage.getMapId({
      region: JSON.stringify(regionRect),
      dimensions: "600x600",
    });

    const exportFileName = `MODIS_NDVI_${startDate}_to_${endDate}`;

    const thumbParams = {
      dimensions: 1024,
      region: catchmentGeom,
      format: "png",
      crs: "EPSG:32632",
    };
    const thumbUrl = visImage.getThumbURL(thumbParams);

    return NextResponse.json({
      tileUrl: mapId.urlFormat,
      ndviMin,
      ndviMax,
      ndviMean,
      monthlyMeans: monthlyStatsList, // [{year, month, ndvi, count}]
      exportStarted: true,
      exportFileName,
      thumbUrl,
      message: `NDVI export from MODIS MCD43A4_006 (16-day) for ${startDate} to ${endDate} completed.`,
    });
  } catch (err) {
    console.error("MODIS NDVI Catchment Error:", err);
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}
