#!/usr/bin/env python3
# ✅ Filename: definitions.py
# 📦 Purpose: Register Dagster job and sensor

from dagster import Definitions, sensor, RunRequest, SkipReason, job
import os

DATA_DIR = os.path.expanduser("~/scr/data")

@job
def ingest_csv():
    pass

@sensor(job=ingest_csv)
def bronze_file_sensor(context):
    csv_files = [f for f in os.listdir(DATA_DIR) if f.endswith(".csv")]
    if not csv_files:
        yield SkipReason("No new CSV files found.")
        return
    for filename in csv_files:
        yield RunRequest(
            run_key=f"ingest_{filename}",
            run_config={},
            tags={"filename": filename},
        )

defs = Definitions(
    jobs=[ingest_csv],
    sensors=[bronze_file_sensor],
)
