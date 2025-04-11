#!/usr/bin/env python3
from dagster import asset, get_dagster_logger
from sqlalchemy import create_engine, text
import polars as pl
import os
from pathlib import Path

BRONZE_SCHEMA = "bronze"
POSTGRES_DB = "postgres"
DATA_DIR = Path.home() / "scr" / "data"

@asset
def bronze_ingest(context, file_path: str):
    logger = get_dagster_logger()
    file = Path(file_path)
    table_name = file.stem.lower()
    logger.info(f"📥 Ingesting {file.name} into table bronze.{table_name}")

    username = "postgres"
    password = os.getenv("POSTGRES_PASSWORD", "")
    engine = create_engine(f"postgresql://{username}:{password}@localhost/{POSTGRES_DB}")

    with engine.connect() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {BRONZE_SCHEMA}"))

    df = pl.read_csv(file)
    df_pd = df.to_pandas()
    df_pd.to_sql(name=table_name, con=engine, schema=BRONZE_SCHEMA, if_exists="replace", index=False)

    logger.info(f"✅ Loaded {file.name} into {BRONZE_SCHEMA}.{table_name}")
