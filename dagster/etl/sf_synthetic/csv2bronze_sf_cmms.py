#!/usr/bin/env python3
"""
csv2bronze_sf_cmms.py

Loads CMMS work order data from a synthetic source into the `bronze.cmms` table.
Source file: /home/blair/scr/scripts/bronze/synthetic/SF/sf_cmms.csv
"""

import polars as pl
from sqlalchemy import create_engine
import getpass
import os
from pathlib import Path

# Configuration
CSV_PATH = Path("/home/blair/scr/scripts/bronze/synthetic/SF/sf_cmms.csv")
TABLE_NAME = "sf_cmms"
SCHEMA = "bronze"
SITE_CODE = CSV_PATH.parent.name
SOURCE_TYPE = CSV_PATH.parent.parent.name

# PostgreSQL connection
pg_user = input("PostgreSQL user: ")
pg_pass = getpass.getpass("PostgreSQL password: ")
engine = create_engine(f"postgresql://{pg_user}:{pg_pass}@localhost:5432/analytics")

# Load and enrich
if not CSV_PATH.exists():
    print(f"⚠️ File not found: {CSV_PATH}")
    exit(1)

df = pl.read_csv(CSV_PATH).with_columns([
    pl.lit(SITE_CODE).alias("site_code"),
    pl.lit(SOURCE_TYPE).alias("source_type")
])

df.write_database(
    table_name=f"{SCHEMA}.{TABLE_NAME}",
    connection=engine,
    if_table_exists="replace"
)

print(f"✅ Loaded {df.shape[0]} CMMS records into {SCHEMA}.{TABLE_NAME}")
