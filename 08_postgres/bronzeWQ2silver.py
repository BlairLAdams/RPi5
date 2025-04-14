#!/usr/bin/env python3
# bronzeWQ2silver.py

"""
This script connects to your PostgreSQL 'metadb' database, creates a new silver schema called 'silverWQ',
and populates it based on water quality data stored in the bronze layer (table waterQuality in the bronzeWQ schema).
It normalizes water quality parameters using Pint, calculates conversion factors,
and adds a brief description of the conversion for each parameter.
"""

import psycopg2
from pint import UnitRegistry
import getpass

def main():
    # Prompt for PostgreSQL connection details using default values.
    host = input("Enter PostgreSQL host (default 'localhost'): ") or "localhost"
    port_input = input("Enter PostgreSQL port (default 5432): ") or "5432"
    try:
        port = int(port_input)
    except ValueError:
        print("Invalid port number. Using default port 5432.")
        port = 5432
    database = input("Enter database name (default 'metadb'): ") or "metadb"
    user = input("Enter your PostgreSQL username: ")
    password = getpass.getpass("Enter your PostgreSQL password: ")
    
    # Build connection parameters.
    conn_params = {
        "host": host,
        "port": port,
        "database": database,
        "user": user,
        "password": password
    }
    
    # Initialize a UnitRegistry instance from Pint.
    ureg = UnitRegistry()

    try:
        # Connect to PostgreSQL.
        conn = psycopg2.connect(**conn_params)
        conn.autocommit = True
        cur = conn.cursor()
        
        # Create silverWQ schema if it doesn't exist.
        cur.execute("CREATE SCHEMA IF NOT EXISTS silverWQ;")
        print("Schema silverWQ created (or already exists).")
        
        # Drop existing silverWQ tables to start fresh.
        drop_queries = [
            "DROP TABLE IF EXISTS silverWQ.dim_date;",
            "DROP TABLE IF EXISTS silverWQ.dim_location;",
            "DROP TABLE IF EXISTS silverWQ.fact_lab_results;"
        ]
        for query in drop_queries:
            cur.execute(query)
            print("Executed:", query)
        
        # Create the dim_date table.
        create_dim_date = """
        CREATE TABLE silverWQ.dim_date (
            full_date timestamp PRIMARY KEY,
            year int,
            month int,
            day int,
            day_name text
        );
        """
        cur.execute(create_dim_date)
        print("Table silverWQ.dim_date created.")
        
        # Create the dim_location table.
        create_dim_location = """
        CREATE TABLE silverWQ.dim_location (
            site_name text PRIMARY KEY,
            latitude numeric,
            longitude numeric
        );
        """
        cur.execute(create_dim_location)
        print("Table silverWQ.dim_location created.")
        
        # Create the fact table with additional columns for conversion factors and calculation descriptions.
        create_fact = """
        CREATE TABLE silverWQ.fact_lab_results (
            sample_id int PRIMARY KEY,
            sample_date timestamp,
            site_name text,
            pH numeric,
            pH_conversion_factor numeric,
            pH_calc_description text,
            
            dissolved_oxygen numeric,         -- normalized to mg/L
            do_conversion_factor numeric,
            do_calc_description text,
            
            turbidity numeric,                -- normalized to NTU
            turbidity_conversion_factor numeric,
            turbidity_calc_description text,
            
            conductivity numeric,             -- normalized to uS/cm
            conductivity_conversion_factor numeric,
            conductivity_calc_description text,
            
            temperature numeric,              -- normalized to degC
            temperature_conversion_factor numeric,
            temperature_calc_description text
        );
        """
        cur.execute(create_fact)
        print("Table silverWQ.fact_lab_results created.")
        
        # Populate dim_date from distinct sample dates, converting Collect_DateTime to a timestamp.
        cur.execute('''
            SELECT DISTINCT to_timestamp("Collect_DateTime", 'MM/DD/YYYY HH12:MI:SS AM') AS sample_date 
            FROM "bronzeWQ"."waterQuality";
        ''')
        dates = cur.fetchall()
        for (sample_date,) in dates:
            if sample_date is None:
                continue
            year = sample_date.year
            month = sample_date.month
            day = sample_date.day
            day_name = sample_date.strftime("%A")
            cur.execute("""
                INSERT INTO silverWQ.dim_date (full_date, year, month, day, day_name)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (full_date) DO NOTHING;
            """, (sample_date, year, month, day, day_name))
        print("dim_date populated.")
        
        # Populate dim_location from distinct site information.
        cur.execute('SELECT DISTINCT "Site", NULL AS latitude, NULL AS longitude FROM "bronzeWQ"."waterQuality";')
        locs = cur.fetchall()
        for site_name, latitude, longitude in locs:
            if site_name is None:
                continue
            cur.execute("""
                INSERT INTO silverWQ.dim_location (site_name, latitude, longitude)
                VALUES (%s, %s, %s)
                ON CONFLICT (site_name) DO NOTHING;
            """, (site_name, latitude, longitude))
        print("dim_location populated.")
        
        # Query rows from the bronze layer.
        cur.execute('''
            SELECT 
              "Sample_ID",
              to_timestamp("Collect_DateTime", 'MM/DD/YYYY HH12:MI:SS AM') AS sample_date,
              "Site",
              "pH",
              "dissolved_oxygen_value",
              "dissolved_oxygen_unit",
              "turbidity_value",
              "turbidity_unit",
              "conductivity_value",
              "conductivity_unit",
              "temperature_value",
              "temperature_unit"
            FROM "bronzeWQ"."waterQuality";
        ''')
        rows = cur.fetchall()
        print(f"Processing {len(rows)} rows from bronzeWQ.waterQuality ...")
        
        # Process each row: normalize units, compute conversion factors, and add calculation notes.
        for row in rows:
            (sample_id, sample_date, site_name, ph,
             do_val, do_unit, turb_val, turb_unit,
             cond_val, cond_unit, temp_val, temp_unit) = row
            
            # pH: No conversion necessary.
            ph_cf = 1.0
            ph_calc_desc = "No conversion required"
            
            # Normalize dissolved oxygen to mg/L.
            try:
                do_quantity = do_val * ureg(do_unit)
                normalized_do = do_quantity.to("mg/l").magnitude
                do_cf = normalized_do / do_val if do_val != 0 else None
                do_calc_desc = f"Converted {do_val} {do_unit} to {normalized_do} mg/L"
            except Exception as e:
                print(f"Error normalizing dissolved oxygen for sample {sample_id}: {e}")
                normalized_do = None
                do_cf = None
                do_calc_desc = "Conversion error"
            
            # Normalize turbidity to NTU.
            try:
                turb_quantity = turb_val * ureg(turb_unit)
                normalized_turb = turb_quantity.to("ntu").magnitude
                turb_cf = normalized_turb / turb_val if turb_val != 0 else None
                turb_calc_desc = f"Converted {turb_val} {turb_unit} to {normalized_turb} NTU"
            except Exception as e:
                print(f"Error normalizing turbidity for sample {sample_id}: {e}")
                normalized_turb = None
                turb_cf = None
                turb_calc_desc = "Conversion error"
            
            # Normalize conductivity to uS/cm.
            try:
                cond_quantity = cond_val * ureg(cond_unit)
                normalized_cond = cond_quantity.to("uS/cm").magnitude
                cond_cf = normalized_cond / cond_val if cond_val != 0 else None
                cond_calc_desc = f"Converted {cond_val} {cond_unit} to {normalized_cond} uS/cm"
            except Exception as e:
                print(f"Error normalizing conductivity for sample {sample_id}: {e}")
                normalized_cond = None
                cond_cf = None
                cond_calc_desc = "Conversion error"
            
            # Normalize temperature to degC.
            try:
                temp_quantity = temp_val * ureg(temp_unit)
                normalized_temp = temp_quantity.to("degC").magnitude
                temp_cf = normalized_temp / temp_val if temp_val != 0 else None
                temp_calc_desc = f"Converted {temp_val} {temp_unit} to {normalized_temp} degC"
            except Exception as e:
                print(f"Error normalizing temperature for sample {sample_id}: {e}")
                normalized_temp = None
                temp_cf = None
                temp_calc_desc = "Conversion error"
            
            # Insert the processed row into fact_lab_results.
            cur.execute("""
                INSERT INTO silverWQ.fact_lab_results 
                (
                    sample_id, sample_date, site_name, 
                    pH, pH_conversion_factor, pH_calc_description,
                    dissolved_oxygen, do_conversion_factor, do_calc_description,
                    turbidity, turbidity_conversion_factor, turbidity_calc_description,
                    conductivity, conductivity_conversion_factor, conductivity_calc_description,
                    temperature, temperature_conversion_factor, temperature_calc_description
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
            """, (
                sample_id, sample_date, site_name,
                ph, ph_cf, ph_calc_desc,
                normalized_do, do_cf, do_calc_desc,
                normalized_turb, turb_cf, turb_calc_desc,
                normalized_cond, cond_cf, cond_calc_desc,
                normalized_temp, temp_cf, temp_calc_desc
            ))
        
        print("fact_lab_results populated with normalized values, conversion factors, and calculation descriptions.")
        
        # Clean up and close the connection.
        cur.close()
        conn.close()
        print("SilverWQ schema created and populated successfully in the metadb database.")
    
    except Exception as e:
        print("An error occurred:", e)

if __name__ == '__main__':
    main()
