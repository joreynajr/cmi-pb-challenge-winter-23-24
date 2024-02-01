# Standardization of CMI-PB Multi-omics Datasets
**Updated: 2022.11.25**  
We are now moving towards the second CMI-PB contest for which we have generated new data. @Joaquin is working on re-harmonizing the data such that we have 3 datasets:  
- D0) use the feature overlap between 2020 and 2021 (original and already complete)  
- D1) uses the feature overlap between 2020, 2021, and 2022 (under development)  
- D2) uses the feature overlap between 2021 and 2022 (under development)

**Updated: 2022.03.31**  
At this point this repository stores the codes to standardize (mostly) the CMI-PB datasets between 2020 and 2021. To access these datasets please check out: https://github.com/joreynajr/cmi-pb-multiomics/tree/main/results/main/cmi_pb_datasets/processed/harmonized

## Processing Steps
Download the data by using:
```
bash workflow/scripts/download_from_webpage_links.sh
```
Note: Don't use `workflow/scripts/download_from_ftp_server.sh`, not working due to certificate issues.

Aftewards run the standarizing notebook with Jupyter:
```
workflow/notebooks/development/Standardize_data.ipynb
```

## Ongoing Problems & Brainstorming
- Normalization Issue for Ab titer data, scaling difference between Abtiter values for 2020 and 2021 
  - We can try...
