#!/usr/bin/env python3
"""
generate_lake_merced_cmms.py

Generates synthetic CMMS work orders for Lake Merced infrastructure,
covering a range of operational and maintenance scenarios. Work orders
span assets such as reservoirs, valves, analyzers, flow meters, and
dosing equipment.

Each record includes fields commonly found in a real CMMS system:
- Asset ID
- Location
- Type
- Work Type (PM, CM, Inspection)
- Priority and Status
- Work Order Dates
- Cost and Notes

Output:
- ~/scr/scripts/bronze_raw/synthetic/SF/cmms_work_orders.csv
"""

import pandas as pd
import numpy as np
import os
from datetime import datetime, timedelta
import random

# Define the output path for the work orders CSV
output_path = os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF/cmms_work_orders.csv")

# Define the Lake Merced assets to be included in CMMS history
assets = [
    {"asset_id": "LM_RES_WEST", "cmms_name": "LM-WB-RES01", "location": "West Basin", "type": "Reservoir"},
    {"asset_id": "LM_RES_EAST", "cmms_name": "LM-EB-RES01", "location": "East Basin", "type": "Reservoir"},
    {"asset_id": "LM_CL2_MON", "cmms_name": "LM-MON-CL201", "location": "Analyzer Station", "type": "Analyzer"},
    {"asset_id": "LM_GV01", "cmms_name": "LM-WB-GV01", "location": "West Outlet", "type": "Gate Valve"},
    {"asset_id": "LM_GV02", "cmms_name": "LM-EB-GV02", "location": "East Outlet", "type": "Gate Valve"},
    {"asset_id": "LM_FM01", "cmms_name": "LM-WB-FM01", "location": "West Basin", "type": "Flow Meter"},
    {"asset_id": "LM_FM02", "cmms_name": "LM-EB-FM02", "location": "East Basin", "type": "Flow Meter"},
    {"asset_id": "LM_BST01", "cmms_name": "LM-BS-01", "location": "Transfer Station", "type": "Booster Pump"},
    {"asset_id": "LM_CLD01", "cmms_name": "LM-CLD-01", "location": "Chemical Room", "type": "Dosing Line"}
]

# Define possible work order fields
work_types = ["Preventive", "Corrective", "Inspection", "Calibration", "Emergency"]
priorities = ["Low", "Medium", "High"]
statuses = ["Completed", "In Progress", "Deferred"]
notes = [
    "Routine inspection completed.",
    "Pump seal replaced after vibration alert.",
    "Sample line flushed and analyzer recalibrated.",
    "Gate valve leak identified and repaired.",
    "Preventive maintenance per schedule.",
    "Flow sensor recalibrated after drift detection.",
    "Emergency shutdown due to pressure spike."
]

# Generate synthetic work orders across a 12-month range
start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 12, 31)
work_orders = []
wo_id_counter = 1000

# Loop through assets and generate work orders per asset
for asset in assets:
    for _ in range(random.randint(8, 15)):  # Generate 8–15 work orders per asset
        opened = start_date + timedelta(days=random.randint(0, 364))
        duration = random.randint(1, 7)
        closed = opened + timedelta(days=duration)

        work_orders.append({
            "wo_id": f"WO{wo_id_counter}",
            "asset_id": asset["asset_id"],
            "cmms_name": asset["cmms_name"],
            "location": asset["location"],
            "type": asset["type"],
            "work_type": random.choice(work_types),
            "priority": random.choice(priorities),
            "status": random.choice(statuses),
            "opened_date": opened.date().isoformat(),
            "closed_date": closed.date().isoformat(),
            "cost": round(np.random.uniform(150, 3500), 2),
            "notes": random.choice(notes)
        })

        wo_id_counter += 1

# Convert to DataFrame and write to file
df = pd.DataFrame(work_orders)
os.makedirs(os.path.dirname(output_path), exist_ok=True)
df.to_csv(output_path, index=False)

# Display confirmation and preview
print(f"✅ CMMS work orders saved to: {output_path}")
print(df.head())
