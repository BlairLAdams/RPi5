#!/usr/bin/env python3
# synthetic_assets.py

"""
Dagster asset definitions for synthetic Lake Merced datasets:
- SCADA tags (hourly, 2024)
- CMMS work orders (event-based)
- LIMS samples (daily)
- Asset registry (static)

Writes CSVs into: ~/scr/scripts/bronze_raw/synthetic/SF/
"""

from dagster import asset
from pathlib import Path
import polars as pl
import random
import pandas as pd
from datetime import datetime, timedelta

# 📁 Output path
BASE_DIR = Path.home() / "scr/scripts/bronze_raw/synthetic/SF"
BASE_DIR.mkdir(parents=True, exist_ok=True)


@asset
def asset_registry():
    rows = [
        {
            "asset_id": "LM_RES_WEST",
            "site_code": "LAKE_MERCED_WEST_OUTLET",
            "location": "Lake Merced - West Basin",
            "scada_tag_prefix": "LAKEMERCED.WESTBASIN",
            "cmms_name": "LM-WB-RES01",
            "type": "Reservoir",
            "criticality": "High"
        },
        {
            "asset_id": "LM_RES_EAST",
            "site_code": "LAKE_MERCED_EAST_OUTLET",
            "location": "Lake Merced - East Basin",
            "scada_tag_prefix": "LAKEMERCED.EASTBASIN",
            "cmms_name": "LM-EB-RES01",
            "type": "Reservoir",
            "criticality": "High"
        },
        {
            "asset_id": "LM_GV01",
            "site_code": "LAKE_MERCED_GV01",
            "location": "Gate Valve - West Outlet",
            "scada_tag_prefix": "LAKEMERCED.GATEVALVE01",
            "cmms_name": "LM-WB-GV01",
            "type": "Valve",
            "criticality": "Medium"
        },
        {
            "asset_id": "LM_CL2_MON",
            "site_code": "LAKE_MERCED_EAST_OUTLET",
            "location": "Chlorine Monitoring Station",
            "scada_tag_prefix": "LAKEMERCED.EASTBASIN.MONITOR",
            "cmms_name": "LM-EB-MON01",
            "type": "Analyzer",
            "criticality": "High"
        }
    ]
    pl.DataFrame(rows).write_csv(BASE_DIR / "asset_registry.csv")


@asset(deps=[asset_registry])
def scada_tags():
    start = datetime(2024, 1, 1)
    end = datetime(2024, 12, 31, 23)
    delta = timedelta(hours=1)
    tags = ["CL2_RESIDUAL", "TURBIDITY", "PH", "FM01.FLOW", "AMPS"]
    zones = ["WESTBASIN", "EASTBASIN"]

    rows = []
    t = start
    while t <= end:
        for z in zones:
            for tag in tags:
                rows.append({
                    "timestamp": t,
                    "tag_name": f"LM.{z}.{tag}",
                    "value": round(random.uniform(0.0, 100.0), 2),
                    "units": "mg/L" if "CL2" in tag else "NTU" if "TURBIDITY" in tag else "pH" if "PH" in tag else "%" if "AMPS" in tag else "gpm",
                    "status": "Good" if random.random() > 0.03 else "Suspect"
                })
        t += delta

    pl.DataFrame(rows).write_csv(BASE_DIR / "scada_tags.csv")


@asset(deps=[asset_registry])
def cmms_work_orders():
    assets = ["LM_RES_WEST", "LM_RES_EAST", "LM_CL2_MON", "LM_GV01"]
    start = datetime(2024, 1, 1)
    rows = []

    for i in range(110):
        asset_id = random.choice(assets)
        days_offset = random.randint(0, 360)
        open_date = start + timedelta(days=days_offset)
        close_date = open_date + timedelta(days=random.randint(1, 5))
        cost = round(random.uniform(100, 3500), 2)

        rows.append({
            "wo_id": f"WO{1000 + i}",
            "asset_id": asset_id,
            "cmms_name": f"LM-WORK-{i}",
            "location": "West Basin" if "WEST" in asset_id else "East Basin",
            "type": "Repair",
            "work_type": "Preventive" if i % 3 else "Emergency",
            "priority": "High" if i % 5 == 0 else "Medium",
            "status": "Closed",
            "opened_date": open_date.date(),
            "closed_date": close_date.date(),
            "cost": cost,
            "notes": "Routine maintenance" if i % 2 == 0 else "Sensor recalibrated"
        })

    pl.DataFrame(rows).write_csv(BASE_DIR / "cmms_work_orders.csv")


@asset(deps=[asset_registry])
def lims_samples():
    analytes = ["Chlorine", "Turbidity", "pH"]
    methods = {"Chlorine": "DPD", "Turbidity": "Nephel", "pH": "Probe"}
    units = {"Chlorine": "mg/L", "Turbidity": "NTU", "pH": "pH"}
    site_code = "LAKE_MERCED_WEST_OUTLET"

    rows = []
    date = datetime(2024, 1, 1)
    sid = 3000
    while date <= datetime(2024, 12, 31):
        for analyte in analytes:
            rows.append({
                "sample_id": f"S{sid}",
                "site_code": site_code,
                "analyte": analyte,
                "value": round(random.uniform(0.1, 8.5), 2),
                "units": units[analyte],
                "method": methods[analyte],
                "sample_time": date.replace(hour=8)
            })
            sid += 1
        date += timedelta(days=1)

    pl.DataFrame(rows).write_csv(BASE_DIR / "lims_samples.csv")
