#!/usr/bin/env python3
"""
csv2bronze_sf_scada.py

Loads SCADA telemetry data from a synthetic source into the `bronze.sf_scada` table.
Source file: /home/blair/scr/scripts/bronze/synthetic/SF/sf_scada.csv
"""

import polars as pl
from sqlalchemy import create_engine
from datetime import datetime
import os
from pathlib import Path

# Configuration
CSV_PATH = Path("/home/blair/scr/scripts/bronze/synthetic/SF/sf_scada.csv")
TABLE_NAME = "sf_scada"
SCHEMA = "bronze"
SITE_CODE = CSV_PATH.parent.name        # 'SF'
SOURCE_TYPE = CSV_PATH.parent.parent.name  # 'synthetic'

# PostgreSQL connection
pg_user = "blair"
pg_pass = os.environ.get("PGPASSWORD")
engine = create_engine(f"postgresql://{pg_user}:{pg_pass}@localhost:5432/analytics")

# Load and enrich
if not CSV_PATH.exists():
    print(f"⚠️ File not found: {CSV_PATH}")
    exit(1)

df = pl.read_csv(CSV_PATH).with_columns([
    pl.lit(SITE_CODE).alias("site_code"),
    pl.lit(SOURCE_TYPE).alias("source_type"),
    pl.lit(datetime.now()).alias("bronze_ingested_at")
])

df.write_database(
    table_name=f"{SCHEMA}.{TABLE_NAME}",
    connection=engine,
    if_table_exists="replace"
)

print(f"✅ Loaded {df.shape[0]} SCADA records into {SCHEMA}.{TABLE_NAME}")
