#!/usr/bin/env python3
"""
generate_cmms.py

Creates synthetic CMMS work order data for Lake Merced infrastructure,
including a variety of assets such as reservoirs, valves, analyzers, pumps,
flow meters, and dosing equipment.

Each record reflects a realistic work order, with fields such as:
- Asset ID and CMMS name
- Location and asset type
- Work type (Preventive, Corrective, etc.)
- Priority, status, open and close dates
- Maintenance cost and technician notes

Output:
- Path: /home/blair/scr/scripts/bronze/synthetic/SF/cmms.csv
- Columns: wo_id, asset_id, cmms_name, location, type, work_type, priority, status, opened_date, closed_date, cost, notes
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
OUTPUT_PATH = "/home/blair/scr/scripts/bronze/synthetic/SF/cmms.csv"

ASSETS = [
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

WORK_TYPES = ["Preventive", "Corrective", "Inspection", "Calibration", "Emergency"]
PRIORITIES = ["Low", "Medium", "High"]
STATUSES = ["Completed", "In Progress", "Deferred"]
NOTES = [
    "Routine inspection completed.",
    "Pump seal replaced after vibration alert.",
    "Sample line flushed and analyzer recalibrated.",
    "Gate valve leak identified and repaired.",
    "Preventive maintenance per schedule.",
    "Flow sensor recalibrated after drift detection.",
    "Emergency shutdown due to pressure spike."
]

# ─────────────────────────────────────────────────────────────
# Generate Work Orders
# ─────────────────────────────────────────────────────────────
start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 12, 31)

work_orders = []
wo_id_counter = 1000

for asset in ASSETS:
    for _ in range(random.randint(8, 15)):  # Work orders per asset
        opened = start_date + timedelta(days=random.randint(0, 364))
        duration = random.randint(1, 7)
        closed = opened + timedelta(days=duration)

        work_orders.append({
            "wo_id": f"WO{wo_id_counter}",
            "asset_id": asset["asset_id"],
            "cmms_name": asset["cmms_name"],
            "location": asset["location"],
            "type": asset["type"],
            "work_type": random.choice(WORK_TYPES),
            "priority": random.choice(PRIORITIES),
            "status": random.choice(STATUSES),
            "opened_date": opened.date().isoformat(),
            "closed_date": closed.date().isoformat(),
            "cost": round(np.random.uniform(150, 3500), 2),
            "notes": random.choice(NOTES)
        })

        wo_id_counter += 1

# ─────────────────────────────────────────────────────────────
# Save to CSV
# ─────────────────────────────────────────────────────────────
df = pd.DataFrame(work_orders)
os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
df.to_csv(OUTPUT_PATH, index=False)

# ─────────────────────────────────────────────────────────────
# Confirmation
# ─────────────────────────────────────────────────────────────
print(f"✅ CMMS work orders saved to: {OUTPUT_PATH}")
print(df.head())
