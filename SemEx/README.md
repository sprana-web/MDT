SemEx semantic integration

The SemEx directory contains the main artefacts used to demonstrate ontology-mediated access and GeoSPARQL querying in the MDT prototype.

SemEx/ontology/ – Lake–catchment ontology used by the prototype.

SemEx/mappings/ – Ontop OBDA mappings connecting PostgreSQL/PostGIS tables to ontology classes and properties.

SemEx/database/ – Database schema showing the relational tables and spatial geometry structure used in the demonstration.

SemEx/configuration/ – Example Ontop configuration file. Database credentials must be supplied locally by the user.

SemEx/queries/ – Representative SPARQL/GeoSPARQL queries corresponding to the semantic-query demonstrations reported in the manuscript.

Demonstration workflow
The semantic integration workflow used in the prototype is:
PostgreSQL/PostGIS data → Ontop mappings → ontology-mediated virtual knowledge graph → SPARQL/GeoSPARQL queries → query results
To reproduce the semantic-query demonstrations where the required source data are available:
1. Install PostgreSQL with PostGIS and create a database.
2. Create the required relational tables using the provided database schema.
3. Obtain and load the required geospatial datasets from the data providers identified below.
4. Update the Ontop configuration file with the local PostgreSQL connection details.
5. Load the ontology and OBDA mapping files in Ontop.
6. Start the Ontop SPARQL endpoint.
7. Execute the representative queries provided in SemEx/queries/.

The repository provides the ontology, mappings, schema, configuration template and representative queries needed to inspect and reproduce the semantic workflow. However, some source datasets are obtained from third-party providers and are not redistributed in the repository. Consequently, the repository supports inspection and partial reproduction of the demonstrated workflow but should not be interpreted as a fully self-contained reproducibility package.
