#!/usr/bin/env python3
# ✅ Filename: bronzeWQ2silverGeo.py
# 📦 Purpose: Transform bronzeWQ.waterQuality into wide-format silver OLAP schema
# 🧠 Features: Unit normalization, pivoted parameters, dimensions, progress bars, correlation analysis

import psycopg2
import getpass
from pint import UnitRegistry
from tqdm import tqdm
from datetime import datetime
from collections import defaultdict
import pandas as pd
from tabulate import tabulate

# ─────────────────────────────────────────────────────────────────────────────
# 🔧 SETUP UNIT REGISTRY
# ─────────────────────────────────────────────────────────────────────────────
ureg = UnitRegistry()
ureg.define('SU = [] = StandardUnits')
ureg.define('NTU = [] = NephelometricTurbidityUnit')
ureg.define('MPN = [] = MostProbableNumber')

# ─────────────────────────────────────────────────────────────────────────────
# 🗺️ SEATTLE LOCATION MAPPING
# ─────────────────────────────────────────────────────────────────────────────
# Dictionary of Seattle water monitoring locations and their coordinates
# Format: "site_name": (latitude, longitude)
seattle_locations = {
    "alki beach": (47.5767, -122.4169),
    "lake union": (47.6392, -122.3344),
    "green lake": (47.6803, -122.3283),
    "lake washington": (47.6095, -122.2559),
    "elliott bay": (47.6062, -122.3321),
    "duwamish river": (47.5129, -122.3129),
    "thornton creek": (47.7072, -122.2855),
    "puget sound": (47.7237, -122.4713),
    "longfellow creek": (47.5346, -122.3696),
    "matthews beach": (47.6950, -122.2731),
    "carkeek park": (47.7120, -122.3789),
    "discovery park": (47.6574, -122.4139),
    "golden gardens": (47.6917, -122.4030),
    "magnuson park": (47.6809, -122.2534),
    "myrtle edwards park": (47.6182, -122.3598),
    "lincoln park": (47.5308, -122.3961)
}

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
    site TEXT PRIMARY KEY,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
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

# SQL queries for correlations
correlation_queries = {
    "pH vs Dissolved Oxygen": """
    SELECT 
        CORR(pH, dissolved_oxygen) AS correlation_coefficient,
        COUNT(*) AS sample_size
    FROM silverWQ.fact_lab_pivot
    WHERE pH IS NOT NULL AND dissolved_oxygen IS NOT NULL;
    """,
    
    "Temperature vs Dissolved Oxygen": """
    SELECT 
        CORR(temperature, dissolved_oxygen) AS correlation_coefficient,
        COUNT(*) AS sample_size
    FROM silverWQ.fact_lab_pivot
    WHERE temperature IS NOT NULL AND dissolved_oxygen IS NOT NULL;
    """,
    
    "Conductivity vs pH": """
    SELECT 
        CORR(conductivity, pH) AS correlation_coefficient,
        COUNT(*) AS sample_size
    FROM silverWQ.fact_lab_pivot
    WHERE conductivity IS NOT NULL AND pH IS NOT NULL;
    """,
    
    "Turbidity vs Coliform": """
    SELECT 
        CORR(turbidity, coliform) AS correlation_coefficient,
        COUNT(*) AS sample_size
    FROM silverWQ.fact_lab_pivot
    WHERE turbidity IS NOT NULL AND coliform IS NOT NULL;
    """,
    
    "pH vs Temperature": """
    SELECT 
        CORR(pH, temperature) AS correlation_coefficient,
        COUNT(*) AS sample_size
    FROM silverWQ.fact_lab_pivot
    WHERE pH IS NOT NULL AND temperature IS NOT NULL;
    """
}

# ─────────────────────────────────────────────────────────────────────────────
# 📊 PARAMETER NORMALIZATION FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────
def normalize_value(parameter, value, unit):
    """Normalize parameter values based on their type and units."""
    # Skip normalization for pH as it's already on a standard scale
    if parameter.lower() == "ph":
        return value
    
    # For other parameters, convert to base units
    try:
        qty = value * ureg(unit)
        return qty.to_base_units().magnitude
    except:
        # Return original value if conversion fails
        return value

# ─────────────────────────────────────────────────────────────────────────────
# 🔍 LOCATION MAPPING FUNCTION
# ─────────────────────────────────────────────────────────────────────────────
def get_coordinates(site_name):
    """Try to match site name with known Seattle locations to get coordinates."""
    # Clean up site name for matching
    clean_site = site_name.lower().strip()
    
    # Direct match
    if clean_site in seattle_locations:
        return seattle_locations[clean_site]
    
    # Partial match (if site contains known location name)
    for location, coords in seattle_locations.items():
        if location in clean_site or clean_site in location:
            return coords
    
    # No match found
    return None, None

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
    
    # Track parameter statistics for analysis
    param_count = defaultdict(int)
    
    # Track unique sites for coordinate mapping
    unique_sites = set()

    for site, raw_date, parameter, value, unit in tqdm(rows, desc="🔁 Pivoting rows"):
        # Store unique site names
        unique_sites.add(site)
        
        # Normalize date
        try:
            parsed_date = datetime.strptime(raw_date[:10], "%m/%d/%Y").date()
        except ValueError:
            try:
                parsed_date = datetime.strptime(raw_date[:10], "%Y-%m-%d").date()
            except ValueError:
                continue  # Skip invalid date

        # Clean parameter name
        clean_param = parameter.strip().lower().replace(" ", "_")
        
        # Apply appropriate normalization
        normalized_value = normalize_value(clean_param, value, unit)
        
        # Store normalized value
        key = (parsed_date, site)
        grouped[key][clean_param] = normalized_value
        
        # Increment parameter counter
        param_count[clean_param] += 1

    print("🗺️ Processing location coordinates...")
    site_coords = {}
    sites_with_coords = 0
    
    for site in tqdm(unique_sites, desc="🌐 Mapping coordinates"):
        lat, long = get_coordinates(site)
        site_coords[site] = (lat, long)
        if lat is not None and long is not None:
            sites_with_coords += 1
    
    print(f"📍 Found coordinates for {sites_with_coords} out of {len(unique_sites)} sites")

    print("📤 Inserting dimension and fact records...")
    # Insert locations with coordinates
    for site, (lat, long) in tqdm(site_coords.items(), desc="📍 Inserting locations"):
        cur.execute(
            "INSERT INTO silverWQ.dim_location (site, latitude, longitude) VALUES (%s, %s, %s);", 
            (site, lat, long)
        )
    
    # Insert dates and fact table records
    for (sample_date, site), param_dict in tqdm(grouped.items(), desc="📦 Inserting data"):
        cur.execute("INSERT INTO silverWQ.dim_date (sample_date) VALUES (%s) ON CONFLICT DO NOTHING;", (sample_date,))
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

    # Print parameter statistics
    print("\n📊 Parameter Statistics:")
    for param, count in sorted(param_count.items(), key=lambda x: x[1], reverse=True):
        print(f"  - {param}: {count} measurements")

    print("\n🔄 Calculating Parameter Correlations...")
    correlation_results = []
    
    for correlation_name, query in correlation_queries.items():
        cur.execute(query)
        result = cur.fetchone()
        correlation_coefficient, sample_size = result
        
        if correlation_coefficient is not None:
            # Format coefficient to 3 decimal places
            formatted_coef = f"{correlation_coefficient:.3f}"
            # Add interpretation
            if abs(correlation_coefficient) < 0.3:
                strength = "Weak"
            elif abs(correlation_coefficient) < 0.7:
                strength = "Moderate"
            else:
                strength = "Strong"
                
            direction = "Positive" if correlation_coefficient > 0 else "Negative"
            interpretation = f"{strength} {direction}"
            
            correlation_results.append([
                correlation_name, 
                formatted_coef,
                sample_size,
                interpretation
            ])
    
    # Print correlation results in a table
    print("\n📈 Parameter Correlation Analysis:")
    headers = ["Parameters", "Coefficient", "Sample Size", "Interpretation"]
    print(tabulate(correlation_results, headers=headers, tablefmt="grid"))

    print("\n✅ silverWQ wide-format transformation complete.")

except psycopg2.Error as e:
    print(f"\n❌ PostgreSQL error: {e}")
except Exception as e:
    print(f"\n❌ General error: {e}")
finally:
    if 'cur' in locals():
        cur.close()
    if 'conn' in locals():
        conn.close()