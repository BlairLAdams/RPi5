# ✅ Filename: copySilverToPostgres.py
# 📤 Purpose: Transfer silver-tier OLAP table from DuckDB to PostgreSQL
# 📦 Dependencies: duckdb, polars, sqlalchemy, psycopg2

import duckdb
import polars as pl
from sqlalchemy import create_engine

# ─────────────────────────────────────────────────────────────────────────────
# 🗂️ CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────
DUCKDB_PATH = "/home/blair/scr/08_dbt_duckdb/data/wq_silver.duckdb"
TABLE_NAME = "daily_lab_summary"

POSTGRES_URI = "postgresql+psycopg2://postgres:postgres@localhost:5432/wq"

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 MAIN EXECUTION
# ─────────────────────────────────────────────────────────────────────────────
def copy_table(table_name: str, duck: duckdb.DuckDBPyConnection, pg_engine):
    print(f"📤 Exporting table: {table_name} from DuckDB to Postgres...")

    # DuckDB may not support view materialization with relative parquet references.
    # We SELECT from the view and materialize it into Polars before pushing to Postgres.
    df = pl.read_database(f"SELECT * FROM {table_name}", connection=duck)
    df.write_database(table_name, connection=pg_engine, if_table_exists="replace")

    print(f"✅ Done! Transferred {df.shape[0]} rows to Postgres.")

def main():
    print("🔌 Connecting to DuckDB and Postgres...")
    duck = duckdb.connect(DUCKDB_PATH)
    pg_engine = create_engine(POSTGRES_URI)

    copy_table(TABLE_NAME, duck, pg_engine)

if __name__ == "__main__":
    main()
