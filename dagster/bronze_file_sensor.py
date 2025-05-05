# ✅ Filename: bronze_file_sensor.py
# 📦 Purpose: Watch ~/scr/data/ for new CSVs and trigger Dagster ingestion jobs
# 🧠 Trigger: Dagster sensor logic

import os
from dagster import sensor, RunRequest, SkipReason, job

# 🔍 Directory to watch
DATA_DIR = os.path.expanduser("~/scr/data")

# 🗃️ Dummy job placeholder (replace with actual ingestion job)
@job
def ingest_csv():
    pass

# 🔔 Sensor that checks for new .csv files
@sensor(job=ingest_csv)
def bronze_file_sensor(context):
    csv_files = [f for f in os.listdir(DATA_DIR) if f.endswith(".csv")]

    if not csv_files:
        yield SkipReason("No CSV files found in ~/scr/data.")
        return

    for file in csv_files:
        yield RunRequest(
            run_key=f"ingest_{file}",
            run_config={},  # 🔧 You can define per-file configs here
            tags={"source_file": file},
        )
