# Rewrite the script to include full docstring, structured comments, and organized formatting

script_path = "/mnt/data/generate_scada_tags.py"

script_content = """#!/usr/bin/env python3
\"\"\"
generate_scada_tags.py

Generates synthetic SCADA tag data for Lake Merced water infrastructure assets,
with support for dimensional modeling via an `asset_id` column to support
star-schema joins.

This version includes operational tags for:

- Water quality sensors (CL2, turbidity, pH)
- Tank/reservoir levels
- Flow meters
- Gate valve positions
- Booster pump RPM and amperage
- Dosing rates for chemical lines
- Analyzer status indicators

Data is generated at hourly intervals over a full year starting from 2024-01-01.

Output:
- File: ~/scr/scripts/bronze_raw/synthetic/SF/scada_tags_with_asset_id.csv
- Fields: timestamp, asset_id, tag_name, value, units, status
\"\"\"

import pandas as pd
import numpy as np
import os
from datetime import datetime, timedelta
import random

# Define the output file path
output_path = os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF/scada_tags_with_asset_id.csv")

# Define Lake Merced SCADA tags and associated synthetic metadata (asset_id, tag_name, units, value range)
SCADA_TAGS = [
    {"asset_id": "ASSET_WB_CL2", "tag_name": "LM.WESTBASIN.CL2_RESIDUAL", "units": "mg/L", "min_val": 0.2, "max_val": 1.0},
    {"asset_id": "ASSET_WB_TURB", "tag_name": "LM.WESTBASIN.TURBIDITY", "units": "NTU", "min_val": 0.1, "max_val": 1.5},
    {"asset_id": "ASSET_WB_PH", "tag_name": "LM.WESTBASIN.PH", "units": "pH", "min_val": 6.5, "max_val": 8.5},
    {"asset_id": "ASSET_WB_LVL", "tag_name": "LM.WESTBASIN.LEVEL", "units": "ft", "min_val": 10.0, "max_val": 18.0},
    {"asset_id": "ASSET_EB_CL2", "tag_name": "LM.EASTBASIN.CL2_RESIDUAL", "units": "mg/L", "min_val": 0.2, "max_val": 1.0},
    {"asset_id": "ASSET_EB_TURB", "tag_name": "LM.EASTBASIN.TURBIDITY", "units": "NTU", "min_val": 0.1, "max_val": 1.5},
    {"asset_id": "ASSET_EB_PH", "tag_name": "LM.EASTBASIN.PH", "units": "pH", "min_val": 6.5, "max_val": 8.5},
    {"asset_id": "ASSET_EB_LVL", "tag_name": "LM.EASTBASIN.LEVEL", "units": "ft", "min_val": 10.0, "max_val": 18.0},
    {"asset_id": "ASSET_FM01", "tag_name": "LM.FM01.FLOW", "units": "gpm", "min_val": 150.0, "max_val": 450.0},
    {"asset_id": "ASSET_FM02", "tag_name": "LM.FM02.FLOW", "units": "gpm", "min_val": 140.0, "max_val": 420.0},
    {"asset_id": "ASSET_GV01", "tag_name": "LM.GV01.POSITION", "units": "%", "min_val": 0.0, "max_val": 100.0},
    {"asset_id": "ASSET_GV02", "tag_name": "LM.GV02.POSITION", "units": "%", "min_val": 0.0, "max_val": 100.0},
    {"asset_id": "ASSET_BST01_RPM", "tag_name": "LM.BST01.RPM", "units": "RPM", "min_val": 1800, "max_val": 3600},
    {"asset_id": "ASSET_BST01_AMPS", "tag_name": "LM.BST01.AMPS", "units": "A", "min_val": 12.0, "max_val": 30.0},
    {"asset_id": "ASSET_CLD01", "tag_name": "LM.CLD01.RATE", "units": "mL/min", "min_val": 50.0, "max_val": 300.0},
    {"asset_id": "ASSET_CL2_MON", "tag_name": "LM.CL2_MON.STATUS", "units": "binary", "min_val": 0, "max_val": 1}
]

# Define the time range: hourly readings from 2024-01-01 to 2024-12-31
start_date = datetime(2024, 1, 1)
end_date = start_date + timedelta(days=365)
timestamps = pd.date_range(start=start_date, end=end_date, freq="h")

# Generate records for every timestamp and SCADA tag
records = []
for ts in timestamps:
    for tag in SCADA_TAGS:
        if tag["units"] == "binary":
            value = int(np.random.choice([0, 1], p=[0.97, 0.03]))  # binary status
        else:
            value = round(np.random.uniform(tag["min_val"], tag["max_val"]), 2)

        status = random.choice(["Good", "Good", "Good", "Suspect"])  # biased toward Good

        records.append({
            "timestamp": ts,
            "asset_id": tag["asset_id"],
            "tag_name": tag["tag_name"],
            "value": value,
            "units": tag["units"],
            "status": status
        })

# Create DataFrame and ensure target directory exists
df = pd.DataFrame(records)
os.makedirs(os.path.dirname(output_path), exist_ok=True)

# Save to CSV
df.to_csv(output_path, index=False)

# Confirmation
print(f"✅ SCADA data with asset_id saved to: {output_path}")
print(df.head())
"""

# Write to file
with open(script_path, "w") as f:
    f.write(script_content)

script_path
