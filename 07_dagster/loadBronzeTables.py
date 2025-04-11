#!/usr/bin/env python3

# ✅ Purpose: Load CSV data into Postgres bronze schema using Polars + SQLAlchemy
# ✅ Notes:
#   - Requires pandas, polars, sqlalchemy, psycopg2, pyarrow
#   - Run within activated venv

import polars as pl
import pandas as pd
from sqlalchemy import create_engine, text
from getpass import getpass
import os

# ─────────────────────────────────────────────────────────────────────────────
# 📁 CONFIGURE FILE PATHS
# ─────────────────────────────────────────────────────────────────────────────
WQ_FILE = os.path.expanduser("~/scr/data/waterQuality.csv")
ENERGY_FILE = os.path.expanduser("~/scr/data/energyUse.csv")
SCHEMA_NAME = "bronze"

# ─────────────────────────────────────────────────────────────────────────────
# 🔁 FUNCTION TO LOAD A CSV INTO POSTGRES
# ─────────────────────────────────────────────────────────────────────────────
def load_csv_to_postgres(csv_path, table_name, engine):
    print(f"📥 Loading {table_name} from {csv_path} ...")
    df = pl.read_csv(csv_path)
    df_pd = df.to_pandas()
    df_pd.to_sql(
        name=table_name,
        con=engine,
        schema=SCHEMA_NAME,
        if_exists="replace",
        index=False
    )
    print(f"✅ {table_name} table loaded successfully.\n")

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 MAIN EXECUTION
# ─────────────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    username = input("👤 Enter Postgres username: ")
    password = getpass(f"🔑 Enter password for Postgres user '{username}': ")
    db_url = f"postgresql://{username}:{password}@localhost:5432/postgres"
    engine = create_engine(db_url)

    print("🔎 Ensuring 'bronze' schema exists...")
    with engine.connect() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {SCHEMA_NAME}"))
        conn.commit()

    load_csv_to_postgres(WQ_FILE, "water_quality", engine)
    load_csv_to_postgres(ENERGY_FILE, "energy_use", engine)
