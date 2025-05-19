#!/usr/bin/env python3
"""
generate_scada.py

Generates synthetic SCADA data for Lake Merced infrastructure assets with a star-schema-friendly `asset_id`.

This script simulates operational telemetry for:
- Water quality parameters (e.g., CL2 residual, turbidity, pH)
- Storage tank levels
- Flow meters
- Valve positions
- Pump RPM and amperage
- Chemical dosing rates
- Binary analyzer status flags

The generated data supports dimensional modeling and is suitable for ingestion into a Bronze layer of a medallion architecture.

Output:
- Path: ~/scr/scripts/bronze/synthetic/SF/scada.csv
- Columns: timestamp, asset_id, tag_name, value, units, status
"""

# ─────────────────────────────────────────────────────────────
# Imports
# ─────────────────────────────────────────────────────────────
import os
import random
from datetime import datetime, timedelta

import numpy as np
import pandas as pd

# ─────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────
OUTPUT_PATH = os.path.expanduser("~/scr/scripts/bronze/synthetic/SF/scada.csv")

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

# ─────────────────────────────────────────────────────────────
# Generate Time Series Data
# ─────────────────────────────────────────────────────────────
start_date = datetime(2024, 1, 1)
end_date = start_date + timedelta(days=365)
timestamps = pd.date_range(start=start_date, end=end_date, freq="h")

records = []
for ts in timestamps:
    for tag in SCADA_TAGS:
        if tag["units"] == "binary":
            value = int(np.random.choice([0, 1], p=[0.97, 0.03]))
        else:
            value = round(np.random.uniform(tag["min_val"], tag["max_val"]), 2)

        status = random.choice(["Good", "Good", "Good", "Suspect"])

        records.append({
            "timestamp": ts,
            "asset_id": tag["asset_id"],
            "tag_name": tag["tag_name"],
            "value": value,
            "units": tag["units"],
            "status": status
        })

# ─────────────────────────────────────────────────────────────
# Output to CSV
# ─────────────────────────────────────────────────────────────
df = pd.DataFrame(records)
os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
df.to_csv(OUTPUT_PATH, index=False)

# ─────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────
print(f"✅ SCADA data with asset_id saved to: {OUTPUT_PATH}")
print(df.head())
