from dagster import Definitions
from .extract_bronze_to_parquet import extract_bronze_to_parquet

defs = Definitions(
    assets=[extract_bronze_to_parquet]
)

