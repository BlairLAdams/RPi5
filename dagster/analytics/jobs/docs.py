from dagster import Definitions, define_asset_job
from analytics.assets import all_assets
from analytics.sensors.docs_sensor import trigger_generate_sf_scada_docs

# Job to run the docs generation asset
generate_sf_scada_docs = define_asset_job(
    name="generate_sf_scada_docs",
    selection=["generate_sf_scada_docs_asset"]
)

defs = Definitions(
    assets=all_assets,
    jobs=[generate_sf_scada_docs],
    sensors=[trigger_generate_sf_scada_docs],
)
