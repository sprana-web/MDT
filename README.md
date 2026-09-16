## Data sources

The MDT prototype integrates environmental information from several Norwegian and international data services.

### Static geospatial data

Static geospatial datasets, including administrative boundaries, terrain data, hydrological features, and other spatial reference layers, were obtained from **GeoNorge**, the national platform for Norwegian public geospatial data.

- GeoNorge: https://www.geonorge.no/
- GeoNorge map catalogue: https://www.geonorge.no/

Users should consult the metadata and licence information associated with each dataset before reuse.

### Hydrological observations

Near-real-time and historical hydrological observations were accessed through the **NVE Hydrological API (HydAPI)** provided by the Norwegian Water Resources and Energy Directorate.

HydAPI provides access to observations such as water level, discharge, water temperature, groundwater, and related hydrological parameters.

- NVE HydAPI documentation: https://api.nve.no/doc/hydrologiske-data/
- HydAPI endpoint: https://hydapi.nve.no/
- HydAPI Swagger interface: https://hydapi.nve.no/swagger/index.html?urls.primaryName=V1

Some NVE API services require user registration and an API key.

### Meteorological observations

Meteorological observations and weather-related information were accessed through services provided by the **Norwegian Meteorological Institute (MET Norway)**.

- MET Weather API: https://api.met.no/
- MET API documentation: https://docs.api.met.no/doc/
- Available MET Weather API products: https://api.met.no/weatherapi/

The MET Weather API provides access to several products, including meteorological observations, forecasts, alerts, and other weather-related datasets.

### Use within the MDT architecture

These external data services are not all accessed through the OBDA layer. Structured relational and geospatial datasets used by the SemEx component are exposed through Ontop and queried using SPARQL/GeoSPARQL. Near-real-time API data can be accessed directly by the monitoring interface, while data that need to be incorporated into the semantic layer may require an intermediate ETL process to transform API responses into structured relational data suitable for ontology mapping.

Remote-sensing datasets are processed separately using Google Earth Engine and are integrated with the MDT through dedicated analytical components rather than by directly virtualising multidimensional raster data through OBDA.
