#!/usr/bin/env python3
"""
sf_copy_bronze2silver.py

Securely copies SCADA, CMMS, and LIMS tables from `bronze` to `silver` schema in PostgreSQL.
Adds commit enforcement, validation logging, and error trace output.
"""

import subprocess
from sqlalchemy import create_engine, text
import traceback

# --- 🔐 Credentials ---
pg_user = "blair"
pg_password = subprocess.check_output(["pass", "dbt/postgres/blair"]).decode("utf-8").strip()
pg_host = "localhost"
pg_port = "5432"
pg_db = "analytics"

# --- 📋 Tables to Copy ---
tables = ["sf_scada", "sf_cmms", "sf_lims"]
source_schema = "bronze"
target_schema = "silver"

# --- 🚀 Connect to DB ---
engine = create_engine(
    f"postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_db}",
    isolation_level="AUTOCOMMIT"  # Needed for CREATE TABLE in some PG configs
)
print(f"🔌 Connecting to: {engine.url}")

with engine.connect() as conn:
    conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {target_schema}"))

    for table in tables:
        source = f"{source_schema}.{table}"
        target = f"{target_schema}.{table}"

        print(f"\n📥 Attempting to copy: {source} → {target}")

        # Check source exists and row count
        try:
            exists = conn.execute(text(f"SELECT to_regclass('{source}')")).scalar()
            if exists is None:
                print(f"⚠️  Source table not found: {source} — skipping")
                continue

            count = conn.execute(text(f"SELECT COUNT(*) FROM {source}")).scalar()
            print(f"🔢 Source {source} has {count} rows")

            conn.execute(text(f"DROP TABLE IF EXISTS {target}"))
            conn.execute(text(f"CREATE TABLE {target} AS TABLE {source}"))

            verify = conn.execute(text(f"SELECT COUNT(*) FROM {target}")).scalar()
            print(f"✅ {target} created with {verify} rows")

        except Exception as e:
            print(f"❌ Exception copying {source} → {target}")
            traceback.print_exc()
