#!/usr/bin/env python3
# ✅ Filename: transformGeocodeSilverSeattle.py
# 📍 Purpose: Use Nominatim geocoder with query enhancements to geocode bronze-layer site names and convert water quality records into OLAP format

import os
import csv
import sys
import time
import psycopg2
import getpass
import requests
from datetime import datetime
from tqdm import tqdm
from collections import defaultdict
import pandas as pd
from sqlalchemy import create_engine, text

# ─────────────────────────────────────────────────────────────────────────────
# 🌍 Improved Nominatim Geocoding
# ─────────────────────────────────────────────────────────────────────────────
def geocode_nominatim(site_name):
    url = "https://nominatim.openstreetmap.org/search"
    params = {
        "q": f"{site_name} water monitoring station, Seattle, WA",
        "format": "json",
        "limit": 1,
        "countrycodes": "us",
        "dedupe": 1,
    }
    try:
        response = requests.get(url, params=params, headers={"User-Agent": "rpi-water-quality-demo"})
        response.raise_for_status()
        data = response.json()
        if data:
            lat = float(data[0]["lat"])
            lon = float(data[0]["lon"])
            return lat, lon
    except Exception as e:
        print(f"❌ Geocoding failed for '{site_name}': {e}")
    return None, None

# ─────────────────────────────────────────────────────────────────────────────
# 🔧 PostgreSQL Connection
# ─────────────────────────────────────────────────────────────────────────────
host = input("Enter PostgreSQL host (default 'localhost'): ") or "localhost"
port = int(input("Enter PostgreSQL port (default 5432): ") or "5432")
dbname = input("Enter database name (default 'analytics'): ") or "analytics"
user = input("Enter your PostgreSQL username: ")
password = getpass.getpass("Enter your PostgreSQL password: ")

conn = psycopg2.connect(host=host, port=port, dbname=dbname, user=user, password=password)
conn.autocommit = True
cur = conn.cursor()

# ─────────────────────────────────────────────────────────────────────────────
# 🧱 Create Schema and Tables
# ─────────────────────────────────────────────────────────────────────────────
print("🧱 Creating schema and OLAP tables...")
cur.execute("""
    CREATE SCHEMA IF NOT EXISTS silver;

    DROP TABLE IF EXISTS silver.fact_seattle_lab;
    DROP TABLE IF EXISTS silver.dim_date;
    DROP TABLE IF EXISTS silver.dim_seattle_station CASCADE;
    DROP TABLE IF EXISTS silver.dim_seattle_area;

    CREATE TABLE silver.dim_seattle_station (
        site TEXT PRIMARY KEY,
        latitude DOUBLE PRECISION,
        longitude DOUBLE PRECISION,
        geom GEOMETRY(POINT, 4326)
    );

    CREATE TABLE silver.dim_seattle_area (
        site TEXT PRIMARY KEY,
        reason TEXT
    );

    CREATE TABLE silver.dim_date (
        sample_date DATE PRIMARY KEY
    );

    CREATE TABLE silver.fact_seattle_lab (
        sample_date DATE REFERENCES silver.dim_date(sample_date),
        site TEXT REFERENCES silver.dim_seattle_station(site),
        pH DOUBLE PRECISION,
        turbidity DOUBLE PRECISION,
        dissolved_oxygen DOUBLE PRECISION,
        conductivity DOUBLE PRECISION,
        temperature DOUBLE PRECISION,
        coliform DOUBLE PRECISION
    );
""")

# ─────────────────────────────────────────────────────────────────────────────
# 📥 Fetch and Transform Data
# ─────────────────────────────────────────────────────────────────────────────
print("📥 Fetching water quality data...")
cur.execute("""
    SELECT "Site", "Collect DateTime", "Parameter", "Value", "Units"
    FROM bronze.seattle_waterquality_raw
    WHERE "Value" IS NOT NULL;
""")
rows = cur.fetchall()
print(f"🔄 Processing {len(rows)} records...")

grouped = defaultdict(dict)
unique_sites = set()
param_count = defaultdict(int)

for site, raw_date, parameter, value, unit in tqdm(rows, desc="Pivoting"):
    unique_sites.add(site)
    try:
        parsed_date = datetime.strptime(raw_date[:10], "%m/%d/%Y").date()
    except ValueError:
        try:
            parsed_date = datetime.strptime(raw_date[:10], "%Y-%m-%d").date()
        except ValueError:
            continue
    clean_param = parameter.strip().lower().replace(" ", "_")
    try:
        normalized_value = float(value)
    except:
        continue
    key = (parsed_date, site)
    grouped[key][clean_param] = normalized_value
    param_count[clean_param] += 1

# ─────────────────────────────────────────────────────────────────────────────
# 🌐 Geocode via Nominatim
# ─────────────────────────────────────────────────────────────────────────────
print("🌐 Geocoding site names using Nominatim...")
inserted = 0
missing = 0

for site in tqdm(unique_sites, desc="Geocoding"):
    lat, lon = geocode_nominatim(site)
    if lat is not None and lon is not None:
        cur.execute(
            """
            INSERT INTO silver.dim_seattle_station (site, latitude, longitude, geom)
            VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326))
            ON CONFLICT (site) DO NOTHING;
            """,
            (site, lat, lon, lon, lat)
        )
        inserted += 1
    else:
        cur.execute(
            "INSERT INTO silver.dim_seattle_area (site, reason) VALUES (%s, %s) ON CONFLICT DO NOTHING;",
            (site, "Not found via Nominatim")
        )
        missing += 1

# ─────────────────────────────────────────────────────────────────────────────
# 📦 Insert dim_date and fact_seattle_lab
# ─────────────────────────────────────────────────────────────────────────────
print("📦 Inserting dim_date and fact_seattle_lab...")

for (sample_date, site), param_dict in tqdm(grouped.items(), desc="Inserting OLAP"):
    cur.execute("INSERT INTO silver.dim_date (sample_date) VALUES (%s) ON CONFLICT DO NOTHING;", (sample_date,))
    cur.execute("SELECT 1 FROM silver.dim_seattle_station WHERE site = %s;", (site,))
    if cur.fetchone():
        cur.execute("""
            INSERT INTO silver.fact_seattle_lab (
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

print(f"✅ Loaded: {inserted} geocoded, {missing} unmatched. OLAP transformation complete.")

cur.close()
conn.close()