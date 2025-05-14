#!/usr/bin/env python3
"""
load_duckdb_lake_merced.py

Loads synthetic Lake Merced datasets (SCADA, CMMS, LIMS, and Asset Registry)
into a DuckDB database file for integrated querying and analysis.

All CSVs are assumed to be pre-generated and saved in consistent paths.

Tables created:
- scada_tags
- cmms_work_orders
- lims_samples
- asset_registry

Output Database:
- ~/scr/scripts/lake_merced.duckdb
"""

import duckdb
import os

# Define file paths to source CSVs
scada_csv = os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF/scada_tags.csv")
cmms_csv = os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF/cmms_work_orders.csv")
lims_csv = os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF/lims_samples.csv")
registry_csv = os.path.expanduser("~/scr/scripts/bronze_raw/synthetic/SF/asset_registry.csv")

# Define the DuckDB output path
db_path = os.path.expanduser("~/scr/scripts/lake_merced.duckdb")

# Connect to the DuckDB database (it will be created if it doesn't exist)
con = duckdb.connect(db_path)

# Create or replace each table using automatic schema inference
con.execute(f"CREATE OR REPLACE TABLE scada_tags AS SELECT * FROM read_csv_auto('{scada_csv}')")
con.execute(f"CREATE OR REPLACE TABLE cmms_work_orders AS SELECT * FROM read_csv_auto('{cmms_csv}')")
con.execute(f"CREATE OR REPLACE TABLE lims_samples AS SELECT * FROM read_csv_auto('{lims_csv}')")
con.execute(f"CREATE OR REPLACE TABLE asset_registry AS SELECT * FROM read_csv_auto('{registry_csv}')")

# Optional: verify by previewing the top 5 records from each table
print("✅ Tables successfully created in DuckDB:")
print("scada_tags:")
print(con.execute("SELECT * FROM scada_tags LIMIT 5").fetchdf())
print("\ncmms_work_orders:")
print(con.execute("SELECT * FROM cmms_work_orders LIMIT 5").fetchdf())
print("\nlims_samples:")
print(con.execute("SELECT * FROM lims_samples LIMIT 5").fetchdf())
print("\nasset_registry:")
print(con.execute("SELECT * FROM asset_registry LIMIT 5").fetchdf())
