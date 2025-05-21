from dagster import Definitions, define_asset_job, AssetSelection
from .assets import all_assets
from .sensors.docs_sensor import generate_docs_sensor

generate_docs_job = define_asset_job(
    name="generate_docs_job",
    selection=AssetSelection.keys("gold_sf_scada") | AssetSelection.keys("generate_dbt_docs")
)

defs = Definitions(
    assets=all_assets,
    jobs=[generate_docs_job],
    sensors=[generate_docs_sensor],
)
