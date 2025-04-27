#!/usr/bin/env python3

import kagglehub
import pandas as pd
from sqlalchemy import create_engine
import os

# Database connection settings
DB_NAME = "grafana"
DB_USER = "grafana"
DB_PASS = "grafana"
DB_HOST = "localhost"
DB_PORT = "5432"

# Step 1: Download the dataset
print("📦 Downloading new water quality dataset...")
dataset_path = kagglehub.dataset_download("sukhmandeepsinghbrar/water-quality")
print(f"✅ Dataset downloaded at: {dataset_path}")

# Step 2: Find all CSV files
csv_files = [os.path.join(dataset_path, f) for f in os.listdir(dataset_path) if f.endswith('.csv')]

if not csv_files:
    raise Exception("🚨 No CSV files found in the downloaded dataset!")

# Step 3: Connect to Postgres
print("🔌 Connecting to PostgreSQL...")
engine = create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# Step 4: Create 'bronze_wq' schema if it doesn't exist
with engine.begin() as conn:
    conn.execute("CREATE SCHEMA IF NOT EXISTS bronze_wq;")
print("✅ Schema 'bronze_wq' ensured.")

# Step 5: Load each CSV into bronze_wq schema
for csv_file in csv_files:
    table_name = os.path.splitext(os.path.basename(csv_file))[0].lower().replace(' ', '_')

    print(f"📥 Loading {csv_file} into bronze_wq.{table_name}...")

    df = pd.read_csv(csv_file)

    # Write to Postgres
    df.to_sql(name=table_name, schema='bronze_wq', con=engine, if_exists='replace', index=False)

print("\n✅ All CSV files loaded successfully into bronze_wq schema!")
