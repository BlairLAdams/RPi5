from dagster import Definitions
from .wq_pipeline import load_bronze_wq, run_dbt

defs = Definitions(
    assets=[load_bronze_wq, run_dbt],
)

