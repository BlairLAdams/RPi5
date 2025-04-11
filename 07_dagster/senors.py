#!/usr/bin/env python3
from dagster import sensor, RunRequest
from pathlib import Path

DATA_DIR = Path.home() / "scr" / "data"
_seen_files = set()

@sensor(job_name="bronze_job")
def bronze_sensor(context):
    global _seen_files
    all_csvs = set(str(p) for p in DATA_DIR.glob("*.csv"))
    new_files = all_csvs - _seen_files

    if new_files:
        _seen_files |= new_files
        return [
            RunRequest(
                run_key=f"bronze-ingest-{Path(f).stem}",
                run_config={"ops": {"bronze_ingest": {"config": {"file_path": f}}}},
                tags={"source": "bronze_sensor"},
            )
            for f in new_files
        ]
    return []
