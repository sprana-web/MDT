# LOCI – Sentinel-2 Land-Cover Analysis

This folder contains the processing workflow used for the LOCI component of the Mjøsa Digital Twin.

The workflow includes:
- Sentinel-2 image retrieval from Google Earth Engine
- temporal and cloud filtering
- image preprocessing
- training-data preparation
- Random Forest classification
- land-cover accuracy assessment
- generation of web-map outputs

The workflow was demonstrated using imagery for the Lake Mjøsa catchment.

Training polygons are not redistributed where source restrictions apply.
Users should provide their own training dataset following the same class structure.