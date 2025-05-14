#!/usr/bin/env python3
"""
generate_lake_merced_lims.py

Generates synthetic LIMS grab sample data for Lake Merced water infrastructure.
Sample sites are aligned with SCADA analyzers and CMMS assets, and include:

- West Basin Outlet
- East Basin Outlet
- Downstream Monitoring Station

Each site is sampled once daily at 8:00 AM for the entire year of 2024.
Analytes include:
- Chlorine
- Turbidity
- pH

Output:
- ~/scr/scripts/bronze_raw/synthetic/SF/lims_samples.csv
- Fields: sample_id, site_code, analyte, value, units, method, sample_time
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os

# Define output location
output_dir = os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF")
lims_output_path = os.path.join(output_dir, "lims_samples.csv")

# Define LIMS sample locations
sample_sites = [
    {"site_code": "LAKE_MERCED_WEST_OUTLET", "location": "West Basin"},
    {"site_code": "LAKE_MERCED_EAST_OUTLET", "location": "East Basin"},
    {"site_code": "LAKE_MERCED_MONITOR1", "location": "Analyzer Station"}
]

# Define analytes with metadata
analytes = [
    {"analyte": "Chlorine", "units": "mg/L", "min_val": 0.2, "max_val": 1.0, "method": "DPD"},
    {"analyte": "Turbidity", "units": "NTU", "min_val": 0.1, "max_val": 1.5, "method": "Nephel"},
    {"analyte": "pH", "units": "pH", "min_val": 6.5, "max_val": 8.5, "method": "Probe"}
]

# Set time range: one sample per day at 8 AM for all of 2024
start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 12, 31)
days = (end_date - start_date).days + 1

# Generate synthetic samples
samples = []
sample_id = 3000

for day in range(days):
    sample_time = start_date + timedelta(days=day, hours=8)
    for site in sample_sites:
        for analyte in analytes:
            value = round(np.random.uniform(analyte["min_val"], analyte["max_val"]), 2)
            samples.append({
                "sample_id": f"S{sample_id}",
                "site_code": site["site_code"],
                "analyte": analyte["analyte"],
                "value": value,
                "units": analyte["units"],
                "method": analyte["method"],
                "sample_time": sample_time.isoformat()
            })
            sample_id += 1

# Convert to DataFrame and save to disk
lims_df = pd.DataFrame(samples)
os.makedirs(output_dir, exist_ok=True)
lims_df.to_csv(lims_output_path, index=False)

# Confirm output
print(f"✅ LIMS data written to: {lims_output_path}")
print(lims_df.head())
