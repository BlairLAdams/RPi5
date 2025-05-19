#!/usr/bin/env python3
"""
sf_db_Bronze2Silver.py

Copies SCADA, CMMS, and LIMS tables from the `bronze` schema to the `silver` schema
in a PostgreSQL database using SQLAlchemy and secure password retrieval via pass.

Usage: Run as a standalone script or wrap in a Dagster op.
"""

import subprocess
from sqlalchemy import create_engine, text

# Securely retrieve password from pass
pg_user = "blair"
pg_password = subprocess.check_output(["pass", "dbt/postgres/blair"]).decode("utf-8").strip()
pg_host = "localhost"
pg_port = "5432"
pg_db = "analytics"

# Define table list and schemas
tables = ["sf_scada", "sf_cmms", "sf_lims"]
source_schema = "bronze"
target_schema = "silver"

# Create database connection
engine = create_engine(f"postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_db}")

# Execute copy for each table
with engine.connect() as conn:
    conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {target_schema}"))

    for table in tables:
        source = f"{source_schema}.{table}"
        target = f"{target_schema}.{table}"

        print(f"📥 Copying {source} → {target}")

        try:
            conn.execute(text(f"DROP TABLE IF EXISTS {target}"))
            conn.execute(text(f"CREATE TABLE {target} AS TABLE {source}"))
            print(f"✅ {target} successfully created from {source}")
        except Exception as e:
            print(f"❌ Failed to copy {source}: {e}")
