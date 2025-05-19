#!/usr/bin/env python3
"""
generate_lims.py

Generates synthetic LIMS grab sample data for Lake Merced water infrastructure,
aligned with SCADA and CMMS monitoring locations.

Each site is sampled once daily at 08:00 AM throughout 2024.

Sample Sites:
- West Basin Outlet
- East Basin Outlet
- Downstream Monitoring Station

Analytes:
- Chlorine (DPD method)
- Turbidity (Nephelometric)
- pH (Probe)

Output:
- Path: /home/blair/scr/scripts/bronze/synthetic/SF/lims.csv
- Columns: sample_id, site_code, analyte, value, units, method, sample_time
"""

# ─────────────────────────────────────────────────────────────
# Imports
# ─────────────────────────────────────────────────────────────
import os
from datetime import datetime, timedelta

import numpy as np
import pandas as pd

# ─────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────
OUTPUT_DIR = "/home/blair/scr/scripts/bronze/synthetic/SF"
OUTPUT_FILE = "lims.csv"
OUTPUT_PATH = os.path.join(OUTPUT_DIR, OUTPUT_FILE)

SAMPLE_SITES = [
    {"site_code": "LAKE_MERCED_WEST_OUTLET", "location": "West Basin"},
    {"site_code": "LAKE_MERCED_EAST_OUTLET", "location": "East Basin"},
    {"site_code": "LAKE_MERCED_MONITOR1", "location": "Analyzer Station"}
]

ANALYTES = [
    {"analyte": "Chlorine", "units": "mg/L", "min_val": 0.2, "max_val": 1.0, "method": "DPD"},
    {"analyte": "Turbidity", "units": "NTU", "min_val": 0.1, "max_val": 1.5, "method": "Nephel"},
    {"analyte": "pH", "units": "pH", "min_val": 6.5, "max_val": 8.5, "method": "Probe"}
]

# ─────────────────────────────────────────────────────────────
# Generate Synthetic Data
# ─────────────────────────────────────────────────────────────
start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 12, 31)
num_days = (end_date - start_date).days + 1

samples = []
sample_id = 3000

for day in range(num_days):
    sample_time = start_date + timedelta(days=day, hours=8)
    for site in SAMPLE_SITES:
        for analyte in ANALYTES:
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

# ─────────────────────────────────────────────────────────────
# Save to CSV
# ─────────────────────────────────────────────────────────────
lims_df = pd.DataFrame(samples)
os.makedirs(OUTPUT_DIR, exist_ok=True)
lims_df.to_csv(OUTPUT_PATH, index=False)

# ─────────────────────────────────────────────────────────────
# Confirmation
# ─────────────────────────────────────────────────────────────
print(f"✅ LIMS data written to: {OUTPUT_PATH}")
print(lims_df.head())