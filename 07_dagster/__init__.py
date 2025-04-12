#!/usr/bin/env python3
# ✅ Filename: __init__.py
# 📦 Purpose: Register Dagster sensor + job in Definitions-based format

import os
from dagster import Definitions, sensor, RunRequest, SkipReason, job

DATA_DIR = os.path.expanduser("~/scr/data")

@job
def ingest_csv():
    pass

@sensor(job=ingest_csv)
def bronze_file_sensor(context):
    csv_files = [f for f in os.listdir(DATA_DIR) if f.endswith(".csv")]
    if not csv_files:
        yield SkipReason("No new CSV files.")
        return

    for f in csv_files:
        yield RunRequest(
            run_key=f"ingest_{f}",
            run_config={},
            tags={"source_file": f},
        )

defs = Definitions(
    jobs=[ingest_csv],
    sensors=[bronze_file_sensor],
)
