# ✅ Filename: extract_bronze_to_parquet.py
# 📦 Purpose: Extract bronze tables from PostgreSQL to local Parquet files
# 🧠 Strategy: Polars + SQLAlchemy with full-schema inference

import polars as pl
from sqlalchemy import create_engine
from dagster import asset
import os

# ─────────────────────────────────────────────────────────────────────────────
# ⚙️ CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────
PG_CONN_STR = "postgresql+psycopg2://blair:1TicketOneRid3!@localhost/metadb"
OUT_DIR = "/home/blair/scr/dbt_duckdb/data/bronze"
TABLES = ["lab_results", "power_readings"]  # ✅ Add more as needed

# ─────────────────────────────────────────────────────────────────────────────
# 🧱 DAGSTER ASSET: EXTRACT TO PARQUET
# ─────────────────────────────────────────────────────────────────────────────
@asset
def extract_bronze_to_parquet():
    engine = create_engine(PG_CONN_STR)
    os.makedirs(OUT_DIR, exist_ok=True)

    for table in TABLES:
        print(f"📤 Extracting {table} from bronze schema...")
        query = f'SELECT * FROM bronze."{table}"'
        df = pl.read_database(query, engine, infer_schema_length=None)
        out_path = f"{OUT_DIR}/{table}.parquet"
        df.write_parquet(out_path)
        print(f"✅ Wrote {out_path}")

