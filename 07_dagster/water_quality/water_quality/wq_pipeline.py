#!/usr/bin/env python3

from dagster import asset
import subprocess

@asset
def load_bronze_wq():
    """Load raw Kaggle water quality CSVs into bronze_wq schema."""
    print("📦 Starting load_bronze_wq.py...")
    result = subprocess.run(["python3", "/home/blair/scr/08_postgres/load_bronze_wq.py"])
    if result.returncode != 0:
        raise Exception("🚨 Bronze_wq load failed!")
    print("✅ Bronze_wq loaded successfully!")
    return "bronze_wq load complete"

@asset(deps=[load_bronze_wq])
def run_dbt():
    """Run dbt models to transform bronze_wq ➔ silver_wq."""
    print("🚀 Starting dbt run...")
    result = subprocess.run(["dbt", "run"], cwd="/home/blair/scr/06_dbt/bronze_to_silver")
    if result.returncode != 0:
        raise Exception("🚨 dbt run failed!")
    print("✅ dbt run completed successfully!")
    return "dbt run complete"

