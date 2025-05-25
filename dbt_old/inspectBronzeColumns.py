#!/usr/bin/env python3
# ✅ Filename: inspectBronzeColumns.py
# 📦 Purpose: Inspect columns in bronze.water_quality and bronze.energy_use
# 🔐 Prompts for secure Postgres login and prints schema details

import getpass
import psycopg2

# 🔐 Prompt for connection
username = input("👤 Enter Postgres username: ")
password = getpass.getpass(f"🔑 Enter password for Postgres user '{username}': ")

# 🔗 Define DB connection
conn = psycopg2.connect(
    dbname="postgres",
    user=username,
    password=password,
    host="localhost",
    port="5432"
)
cur = conn.cursor()

def print_table_columns(schema, table):
    print(f"\n📋 Columns in {schema}.{table}:\n" + "─" * 40)
    cur.execute("""
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = %s AND table_name = %s
        ORDER BY ordinal_position
    """, (schema, table))
    rows = cur.fetchall()
    for name, dtype in rows:
        print(f"{name:<30} {dtype}")
    if not rows:
        print("⚠️ No columns found or table does not exist.")

# 🧪 Inspect bronze tables
print_table_columns("bronze", "water_quality")
print_table_columns("bronze", "energy_use")

# ✅ Cleanup
cur.close()
conn.close()
