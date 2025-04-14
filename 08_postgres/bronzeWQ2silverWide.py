#!/usr/bin/env python3
# ✅ Filename: bronzeWQ2silverWide.py
# 📦 Purpose: Transform bronzeWQ.waterQuality into wide-format silver OLAP schema
# 🧠 Features: Unit normalization, pivoted parameters, dimensions, progress bars

import psycopg2
import getpass
from pint import UnitRegistry
from tqdm import tqdm
from datetime import datetime
from collections import defaultdict

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
# 🧹 SQL SETUP
# ─────────────────────────────────────────────────────────────────────────────
drop_sql = """
DROP SCHEMA IF EXISTS silverWQ CASCADE;
CREATE SCHEMA silverWQ;
"""

create_sql = """
CREATE TABLE silverWQ.dim_location (
    site TEXT PRIMARY KEY
);

CREATE TABLE silverWQ.dim_date (
    sample_date DATE PRIMARY KEY
);

CREATE TABLE silverWQ.fact_lab_pivot (
    sample_date DATE REFERENCES silverWQ.dim_date(sample_date),
    site TEXT REFERENCES silverWQ.dim_location(site),
    pH DOUBLE PRECISION,
    turbidity DOUBLE PRECISION,
    dissolved_oxygen DOUBLE PRECISION,
    conductivity DOUBLE PRECISION,
    temperature DOUBLE PRECISION,
    coliform DOUBLE PRECISION
);
"""

fetch_sql = """
SELECT "Site", "Collect_DateTime", "Parameter", "Value", "Units"
FROM "bronzeWQ"."waterQuality"
WHERE "Value" IS NOT NULL;
"""

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 MAIN TRANSFORMATION LOGIC
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
    cur.execute(drop_sql)
    cur.execute(create_sql)

    print("📥 Fetching source records...")
    cur.execute(fetch_sql)
    rows = cur.fetchall()

    print(f"🔄 Processing {len(rows)} records...")
    grouped = defaultdict(dict)

    for site, raw_date, parameter, value, unit in tqdm(rows, desc="🔁 Pivoting rows"):
        # Normalize date
        try:
            parsed_date = datetime.strptime(raw_date[:10], "%m/%d/%Y").date()
        except ValueError:
            try:
                parsed_date = datetime.strptime(raw_date[:10], "%Y-%m-%d").date()
            except ValueError:
                continue  # Skip invalid date

        # Normalize unit
        try:
            qty = value * ureg(unit)
            normalized_value = qty.to_base_units().magnitude
        except:
            normalized_value = value  # fallback to raw value

        key = (parsed_date, site)
        clean_param = parameter.strip().lower().replace(" ", "_")
        grouped[key][clean_param] = normalized_value

    print("📤 Inserting dimension and fact records...")
    for (sample_date, site), param_dict in tqdm(grouped.items(), desc="📦 Inserting"):
        cur.execute("INSERT INTO silverWQ.dim_date (sample_date) VALUES (%s) ON CONFLICT DO NOTHING;", (sample_date,))
        cur.execute("INSERT INTO silverWQ.dim_location (site) VALUES (%s) ON CONFLICT DO NOTHING;", (site,))
        cur.execute("""
            INSERT INTO silverWQ.fact_lab_pivot (
                sample_date, site,
                pH, turbidity, dissolved_oxygen,
                conductivity, temperature, coliform
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
        """, (
            sample_date, site,
            param_dict.get("ph"),
            param_dict.get("turbidity"),
            param_dict.get("dissolved_oxygen"),
            param_dict.get("conductivity"),
            param_dict.get("temperature"),
            param_dict.get("coliform")
        ))

    print("✅ silverWQ wide-format transformation complete.")

except psycopg2.Error as e:
    print(f"\n❌ PostgreSQL error: {e}")
except Exception as e:
    print(f"\n❌ General error: {e}")
finally:
    if 'cur' in locals():
        cur.close()
    if 'conn' in locals():
        conn.close()
