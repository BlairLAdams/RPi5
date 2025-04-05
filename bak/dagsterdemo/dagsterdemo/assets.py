from dagster import asset
import duckdb

@asset
def hello_duckdb():
    conn = duckdb.connect(database="duckdemo.db", read_only=False)
    conn.execute("CREATE OR REPLACE TABLE hello AS SELECT 'Hello from Dagster + DuckDB!' AS message;")
    conn.close()
