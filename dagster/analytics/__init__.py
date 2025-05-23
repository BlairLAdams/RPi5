from dagster import Definitions
from .assets import all_assets
from .jobs.docs import generate_sf_scada_docs
from .sensors.docs_sensor import trigger_generate_sf_scada_docs

defs = Definitions(
    assets=all_assets,
    jobs=[generate_sf_scada_docs],
    sensors=[trigger_generate_sf_scada_docs],
)
