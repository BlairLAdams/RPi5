#!/usr/bin/env python3

import kagglehub
import pandas as pd
from sqlalchemy import create_engine
import os

# Step 1: Download the dataset
print("Downloading water quality dataset...")
dataset_path = kagglehub.dataset_download("sahirmaharajj/water-quality-data")
print("Dataset downloaded at:", dataset_path)

# Step 2: Find CSV files
csv_files = [os.path.join(dataset_path, f) for f in os.listdir(dataset_path) if f.endswith('.csv')]

if not csv_files:
    raise Exception("No CSV files found!")

# Step 3: Connect to Postgres
print("Connecting to Postgres...")
engine = create_engine('postgresql://grafana:grafana@localhost:5432/grafana')

# Step 4: Create 'bronze' schema if needed
with engine.begin() as conn:
    conn.execute("CREATE SCHEMA IF NOT EXISTS bronze;")
print("Bronze schema ensured.")

# Step 5: Load each CSV into bronze schema
for csv_file in csv_files:
    table_name = os.path.splitext(os.path.basename(csv_file))[0].lower().replace(' ', '_')
    print(f"Loading {csv_file} into bronze.{table_name}...")

    df = pd.read_csv(csv_file)

    df.to_sql(name=table_name, schema='bronze', con=engine, if_exists='replace', index=False)

print("✅ All files loaded successfully into bronze schema!")
