#!/usr/bin/env python3

# 📄 load_bronze_sf.py
# 🎯 Loads SCADA, CMMS, LIMS, and asset registry CSVs for site SF from synthetic source
# 🧠 Only processes files in: ~/scr/scripts/bronze_raw/synthetic/SF

import polars as pl
from sqlalchemy import create_engine
import getpass
import os
from pathlib import Path

# --- 📁 CONFIGURATION ---
TARGET_DIR = Path(os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF"))
TABLE_MAP = {
    "cmms_work_orders.csv": "cmms_work_orders",
    "lims_samples.csv": "lims_samples",
    "scada_tags.csv": "scada_tags",
    "asset_registry.csv": "asset_registry"
}
SCHEMA = "bronze"
SITE_CODE = TARGET_DIR.name           # 'SF'
SOURCE_TYPE = TARGET_DIR.parent.name  # 'synthetic'

# --- 🔐 PostgreSQL Connection ---
pg_user = input("PostgreSQL user: ")
pg_pass = getpass.getpass("PostgreSQL password: ")
pg_host = "localhost"
pg_port = "5432"
pg_db   = "analytics"

connection_url = f"postgresql://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}"
engine = create_engine(connection_url)

# --- 🔄 Process Expected CSVs ---
for filename, table_base in TABLE_MAP.items():
    csv_path = TARGET_DIR / filename
    if not csv_path.exists():
        print(f"⚠️ File missing: {csv_path}")
        continue

    full_table_name = f"{SCHEMA}.{table_base}"
    print(f"📥 Loading {filename} into {full_table_name} (site={SITE_CODE}, source={SOURCE_TYPE})")

    try:
        df = pl.read_csv(csv_path)
        df = df.with_columns([
            pl.lit(SITE_CODE).alias("site_code"),
            pl.lit(SOURCE_TYPE).alias("source_type")
        ])
    except Exception as e:
        print(f"❌ Failed to load {filename}: {e}")
        continue

    try:
        df.write_database(
            table_name=full_table_name,
            connection=engine,
            if_table_exists="replace"  # Use "append" if desired
        )
        print(f"✅ Loaded {df.shape[0]} rows into {full_table_name}")
    except Exception as e:
        print(f"❌ Failed to insert into Postgres: {e}")
