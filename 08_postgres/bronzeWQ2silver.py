#!/usr/bin/env python3
# ✅ Filename: bronzeWQ2silver.py
# 📦 Purpose: Transform bronzeWQ.waterQuality into dimensional OLAP silverWQ schema
# 🧠 Features: Unit normalization, date parsing, progress bar, safe table drops

import psycopg2
import getpass
from pint import UnitRegistry
from tqdm import tqdm
from datetime import datetime

# ─────────────────────────────────────────────────────────────────────────────
# 🔧 SETUP UNIT REGISTRY
# ─────────────────────────────────────────────────────────────────────────────
ureg = UnitRegistry()
ureg.define('SU = [] = StandardUnits')
ureg.define('NTU = [] = NephelometricTurbidityUnit')
ureg.define('MPN = [] = MostProbableNumber')

# ─────────────────────────────────────────────────────────────────────────────
# 📥 PROMPT FOR DATABASE CREDENTIALS
# ─────────────────────────────────────────────────────────────────────────────
host = input("Enter PostgreSQL host (default 'localhost'): ") or "localhost"
port_input = input("Enter PostgreSQL port (default 5432): ") or "5432"
try:
    port = int(port_input)
except ValueError:
    print("❌ Invalid port number")
    exit(1)

dbname = input("Enter database name (default 'metadb'): ") or "metadb"
user = input("Enter your PostgreSQL username: ")
password = getpass.getpass("Enter your PostgreSQL password: ")

# ─────────────────────────────────────────────────────────────────────────────
# 🧹 SQL QUERIES
# ─────────────────────────────────────────────────────────────────────────────
drop_schema_sql = """
DROP SCHEMA IF EXISTS silverWQ CASCADE;
CREATE SCHEMA silverWQ;
"""

create_tables_sql = """
CREATE TABLE silverWQ.dim_location (
    site TEXT PRIMARY KEY
);

CREATE TABLE silverWQ.dim_date (
    sample_date DATE PRIMARY KEY
);

CREATE TABLE silverWQ.fact_lab_results (
    sample_date DATE REFERENCES silverWQ.dim_date(sample_date),
    site TEXT REFERENCES silverWQ.dim_location(site),
    parameter TEXT,
    original_value DOUBLE PRECISION,
    original_unit TEXT,
    normalized_value DOUBLE PRECISION,
    normalized_unit TEXT,
    conversion_factor DOUBLE PRECISION,
    conversion_description TEXT
);
"""

fetch_data_sql = """
SELECT
    "Site",
    "Collect_DateTime",
    "Parameter",
    "Value",
    "Units"
FROM "bronzeWQ"."waterQuality"
WHERE "Value" IS NOT NULL;
"""

insert_dim_location_sql = "INSERT INTO silverWQ.dim_location (site) VALUES (%s) ON CONFLICT DO NOTHING;"
insert_dim_date_sql = "INSERT INTO silverWQ.dim_date (sample_date) VALUES (%s) ON CONFLICT DO NOTHING;"
insert_fact_sql = """
INSERT INTO silverWQ.fact_lab_results (
    sample_date, site, parameter, original_value, original_unit,
    normalized_value, normalized_unit, conversion_factor, conversion_description
) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
"""

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 MAIN SCRIPT LOGIC
# ─────────────────────────────────────────────────────────────────────────────
try:
    conn = psycopg2.connect(
        host=host,
        port=port,
        dbname=dbname,
        user=user,
        password=password
    )
    conn.autocommit = True
    cur = conn.cursor()

    print("🧨 Dropping and recreating silverWQ schema...")
    cur.execute(drop_schema_sql)
    cur.execute(create_tables_sql)

    print("📥 Fetching source records...")
    cur.execute(fetch_data_sql)
    rows = cur.fetchall()

    print(f"🔄 Processing {len(rows)} records...")
    for row in tqdm(rows, desc="🏗️ Building silver layer"):
        site, raw_date, parameter, value, unit = row

        # ─── 📅 DATE NORMALIZATION ────────────────────────────────────────────
        try:
            parsed_date = datetime.strptime(raw_date[:10], "%m/%d/%Y").date()
        except ValueError:
            try:
                parsed_date = datetime.strptime(raw_date[:10], "%Y-%m-%d").date()
            except ValueError:
                continue  # Skip invalid dates

        # ─── 📏 UNIT NORMALIZATION ────────────────────────────────────────────
        try:
            qty = value * ureg(unit)
            normalized_qty = qty.to_base_units()
            norm_value = normalized_qty.magnitude
            norm_unit = str(normalized_qty.units)
            factor = norm_value / value if value != 0 else None
            desc = f"{qty:~P} normalized to {normalized_qty:~P}"
        except Exception as e:
            norm_value = None
            norm_unit = None
            factor = None
            desc = f"⚠️ Conversion failed: {e}"

        # ─── 📤 INSERT DIMENSIONS + FACT ──────────────────────────────────────
        cur.execute(insert_dim_location_sql, (site,))
        cur.execute(insert_dim_date_sql, (parsed_date,))
        cur.execute(insert_fact_sql, (
            parsed_date, site, parameter, value, unit,
            norm_value, norm_unit, factor, desc
        ))

    print("✅ silverWQ transformation complete.")

except psycopg2.Error as e:
    print(f"\n❌ PostgreSQL error: {e}")
except Exception as e:
    print(f"\n❌ General error: {e}")
finally:
    if 'cur' in locals():
        cur.close()
    if 'conn' in locals():
        conn.close()
