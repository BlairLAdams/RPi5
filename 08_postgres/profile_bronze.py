#!/usr/bin/env python3

import psycopg2
import pandas as pd
from sqlalchemy import create_engine

# Database connection settings
DB_NAME = "grafana"
DB_USER = "grafana"
DB_PASS = "grafana"
DB_HOST = "localhost"
DB_PORT = "5432"

# Connect using SQLAlchemy (easier for pandas)
engine = create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# Connect raw (for table listing)
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASS,
    host=DB_HOST,
    port=DB_PORT
)

cursor = conn.cursor()

# Get all tables in the bronze schema
cursor.execute("""
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'bronze'
""")

tables = cursor.fetchall()

print(f"\n📋 Found {len(tables)} tables in schema 'bronze':\n")

for (table_name,) in tables:
    print(f"🔹 Table: bronze.{table_name}")

    # Load table into pandas DataFrame
    df = pd.read_sql(f'SELECT * FROM bronze."{table_name}"', engine)

    print(f"   ➔ Number of records: {len(df)}")
    
    # Field names
    print(f"   ➔ Fields:")

    for col in df.columns:
        # Attempt basic "unit" inference if column name contains common unit keywords
        unit_hint = ""
        if any(u in col.lower() for u in ['ph', 'temp', 'turb', 'solid', 'conduct', 'mg', 'celsius', 'ntu']):
            unit_hint = " (likely unit-related)"
        
        missing_count = df[col].isna().sum()
        
        print(f"      - {col}{unit_hint}, Missing values: {missing_count}")

    print()

cursor.close()
conn.close()
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
