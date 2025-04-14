#!/usr/bin/env python3
# ✅ Filename: importBronzeWQ.py

"""
Connects to PostgreSQL, creates the 'bronzeWQ' schema and 'waterQuality' table,
and bulk loads data from a CSV file. Drops the table each run to prevent duplicates.
"""

import os
import sys
import getpass
import pandas as pd
import psycopg2
from psycopg2 import sql

def infer_postgres_type(series):
    if pd.api.types.is_integer_dtype(series):
        return "INTEGER"
    elif pd.api.types.is_float_dtype(series):
        return "FLOAT"
    else:
        return "TEXT"

def build_create_table_statement(schema, table, df):
    columns = [
        sql.SQL("{} {}").format(
            sql.Identifier(col.strip().replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_")),
            sql.SQL(infer_postgres_type(df[col]))
        )
        for col in df.columns
    ]
    return sql.SQL("CREATE TABLE {}.{} ({});").format(
        sql.Identifier(schema), sql.Identifier(table), sql.SQL(", ").join(columns)
    )

def main():
    host = input("Enter PostgreSQL host (default 'localhost'): ") or "localhost"
    port = int(input("Enter PostgreSQL port (default 5432): ") or 5432)
    db = input("Enter PostgreSQL database name (default 'metadb'): ") or "metadb"
    user = input("Enter your PostgreSQL username: ")
    password = getpass.getpass("Enter your PostgreSQL password: ")

    conn_params = {"host": host, "port": port, "dbname": db, "user": user, "password": password}
    csv_path = "/home/blair/scr/data/waterQuality.csv"

    try:
        df = pd.read_csv(csv_path)
        print("✅ CSV loaded. Preview:")
        print(df.head())
    except Exception as e:
        print(f"❌ Error reading CSV: {e}")
        sys.exit(1)

    schema, table = "bronzeWQ", "waterQuality"
    create_stmt = build_create_table_statement(schema, table, df)

    try:
        conn = psycopg2.connect(**conn_params)
        cur = conn.cursor()
        print("✅ Connected to PostgreSQL.")

        cur.execute(sql.SQL("CREATE SCHEMA IF NOT EXISTS {};").format(sql.Identifier(schema)))
        cur.execute(sql.SQL("DROP TABLE IF EXISTS {}.{};").format(sql.Identifier(schema), sql.Identifier(table)))
        print(f"🧹 Dropped table {schema}.{table} if it existed.")

        cur.execute(create_stmt)
        conn.commit()
        print(f"✅ Table {schema}.{table} created.")

        print("📥 Loading data into PostgreSQL...")
        copy_sql = f'COPY "{schema}"."{table}" FROM STDIN WITH CSV HEADER DELIMITER \',\''
        with open(csv_path, 'r') as f:
            cur.copy_expert(sql=copy_sql, file=f)
        conn.commit()
        print("✅ Data load complete.")

        cur.close()
        conn.close()
    except Exception as e:
        print(f"❌ PostgreSQL error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
