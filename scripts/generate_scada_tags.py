#!/usr/bin/env python3
"""
generate_lake_merced_scada.py

Generates synthetic SCADA tag data for Lake Merced water infrastructure assets.
This enhanced version includes operational tags for:

- Water quality sensors (CL2, turbidity, pH)
- Tank/reservoir levels
- Flow meters
- Gate valve positions
- Booster pump RPM and amperage
- Dosing rates for chemical lines
- Analyzer status indicators

Data is generated at hourly intervals over a full year starting from 2024-01-01.

Output:
- File: ~/scr/scripts/bronze_raw/synthetic/SF/scada_tags.csv
- Fields: timestamp, tag_name, value, units, status
"""

import pandas as pd
import numpy as np
import os
from datetime import datetime, timedelta
import random

# Define the output file path
output_path = os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF/scada_tags.csv")

# Define Lake Merced SCADA tags (tag_name, units, min/max range)
# These are aligned with the expanded CMMS asset list
SCADA_TAGS = [
    # West Basin sensors
    {"tag_name": "LM.WESTBASIN.CL2_RESIDUAL", "units": "mg/L", "min_val": 0.2, "max_val": 1.0},
    {"tag_name": "LM.WESTBASIN.TURBIDITY", "units": "NTU", "min_val": 0.1, "max_val": 1.5},
    {"tag_name": "LM.WESTBASIN.PH", "units": "pH", "min_val": 6.5, "max_val": 8.5},
    {"tag_name": "LM.WESTBASIN.LEVEL", "units": "ft", "min_val": 10.0, "max_val": 18.0},

    # East Basin sensors
    {"tag_name": "LM.EASTBASIN.CL2_RESIDUAL", "units": "mg/L", "min_val": 0.2, "max_val": 1.0},
    {"tag_name": "LM.EASTBASIN.TURBIDITY", "units": "NTU", "min_val": 0.1, "max_val": 1.5},
    {"tag_name": "LM.EASTBASIN.PH", "units": "pH", "min_val": 6.5, "max_val": 8.5},
    {"tag_name": "LM.EASTBASIN.LEVEL", "units": "ft", "min_val": 10.0, "max_val": 18.0},

    # Flow meters
    {"tag_name": "LM.FM01.FLOW", "units": "gpm", "min_val": 150.0, "max_val": 450.0},
    {"tag_name": "LM.FM02.FLOW", "units": "gpm", "min_val": 140.0, "max_val": 420.0},

    # Gate valve positions (0 = closed, 100 = fully open)
    {"tag_name": "LM.GV01.POSITION", "units": "%", "min_val": 0.0, "max_val": 100.0},
    {"tag_name": "LM.GV02.POSITION", "units": "%", "min_val": 0.0, "max_val": 100.0},

    # Booster pump telemetry
    {"tag_name": "LM.BST01.RPM", "units": "RPM", "min_val": 1800, "max_val": 3600},
    {"tag_name": "LM.BST01.AMPS", "units": "A", "min_val": 12.0, "max_val": 30.0},

    # Dosing line rate
    {"tag_name": "LM.CLD01.RATE", "units": "mL/min", "min_val": 50.0, "max_val": 300.0},

    # Analyzer operational status (0 = off, 1 = on)
    {"tag_name": "LM.CL2_MON.STATUS", "units": "binary", "min_val": 0, "max_val": 1}
]

# Define the time range: 1 year of hourly intervals starting January 1, 2024
start_date = datetime(2024, 1, 1)
end_date = start_date + timedelta(days=365)
timestamps = pd.date_range(start=start_date, end=end_date, freq="h")

# Generate synthetic data records for each tag and timestamp
records = []
for ts in timestamps:
    for tag in SCADA_TAGS:
        if tag["units"] == "binary":
            value = int(np.random.choice([0, 1], p=[0.97, 0.03]))  # mostly on
        else:
            value = round(np.random.uniform(tag["min_val"], tag["max_val"]), 2)

        status = random.choice(["Good", "Good", "Good", "Suspect"])

        records.append({
            "timestamp": ts,
            "tag_name": tag["tag_name"],
            "value": value,
            "units": tag["units"],
            "status": status
        })

# Convert records to a DataFrame
scada_df = pd.DataFrame(records)

# Ensure directory exists and save to CSV
os.makedirs(os.path.dirname(output_path), exist_ok=True)
scada_df.to_csv(output_path, index=False)

# Print confirmation and sample rows
print(f"✅ SCADA data saved to: {output_path}")
print(scada_df.head())
