#!/usr/bin/env python3
# ✅ Filename: importBronzeKaggleWaterQuality.py

"""
Downloads the 'sahirmaharajj/water-quality-data' dataset from Kaggle,
combines all CSVs, and loads them into the 'bronze' schema of the PostgreSQL
database 'analytics' as a single table named 'seattle_waterquality_raw'.

- Overwrites the table on each run
- Automatically creates the 'bronze' schema if it doesn't exist
- Combines all CSVs into one large DataFrame using outer join logic
- Verifies the table was created successfully
"""

import os
import sys
import kagglehub
import pandas as pd
from sqlalchemy import create_engine, text

# ─────────────────────────────────────────────
# 🔧 Database Connection Settings
# ─────────────────────────────────────────────

DB_USER = "blair"
DB_PASS = "OneTicket1Rid3"  # 🔒 Consider using getpass for security
DB_NAME = "analytics"
DB_HOST = "localhost"
DB_PORT = "5432"

# 🌍 Target geography prefix
GEO_TAG = "seattle"
TABLE_NAME = f"{GEO_TAG}_waterquality_raw"

# ─────────────────────────────────────────────
# 📦 Step 1: Download Dataset from Kaggle
# ─────────────────────────────────────────────

print("📦 Downloading Kaggle dataset 'sahirmaharajj/water-quality-data'...")
try:
    dataset_path = kagglehub.dataset_download("sukhmandeepsinghbrar/water-quality")
except Exception as e:
    print(f"❌ Kaggle download failed: {e}")
    sys.exit(1)

print(f"✅ Dataset downloaded at: {dataset_path}")

# ─────────────────────────────────────────────
# 📂 Step 2: Locate CSV Files
# ─────────────────────────────────────────────

csv_files = [os.path.join(dataset_path, f) for f in os.listdir(dataset_path) if f.endswith('.csv')]
if not csv_files:
    print("🚨 No CSV files found in downloaded dataset.")
    sys.exit(1)

# ─────────────────────────────────────────────
# 🔌 Step 3: Connect to PostgreSQL and Ensure Schema
# ─────────────────────────────────────────────

engine_url = f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
print(f"🔌 Connecting to PostgreSQL using engine URL: {engine_url}")
engine = create_engine(engine_url)

try:
    with engine.begin() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS bronze;"))
    print("✅ Schema 'bronze' ensured.")
except Exception as e:
    print(f"❌ Failed to create schema: {e}")
    sys.exit(1)

# ─────────────────────────────────────────────
# 📥 Step 4: Combine all CSVs and Load Table
# ─────────────────────────────────────────────

print("📥 Reading and combining all CSV files...")

try:
    dataframes = []
    for file in csv_files:
        print(f"  🔄 Reading {os.path.basename(file)}...")
        df = pd.read_csv(file)
        dataframes.append(df)

    combined_df = pd.concat(dataframes, ignore_index=True, sort=True)
    print(f"✅ Combined dataset shape: {combined_df.shape}")
    print(f"🔍 Columns: {combined_df.columns.tolist()}")

    # Write to PostgreSQL
    print(f"📝 Writing to bronze.{TABLE_NAME} ...")
    combined_df.to_sql(name=TABLE_NAME, schema="bronze", con=engine, if_exists="replace", index=False)
    print(f"✅ Write complete: bronze.{TABLE_NAME} ({len(combined_df)} rows).")

    # Verify table creation
    with engine.begin() as conn:
        verify = conn.execute(text(f"""
            SELECT COUNT(*) FROM information_schema.tables 
            WHERE table_schema = 'bronze' AND table_name = '{TABLE_NAME}';
        """)).scalar()

        if verify == 1:
            print(f"✅ Confirmed: bronze.{TABLE_NAME} exists in 'analytics'.")
        else:
            print(f"❌ Verification failed: bronze.{TABLE_NAME} not found.")

except Exception as e:
    print(f"❌ Failed to load combined dataset: {e}")
    sys.exit(1)
