from pathlib import Path
import json

from dagster import Definitions, define_asset_job, AssetSelection
from dagster_dbt import dbt_assets

from analytics.pipelines.scada_pipeline import scada_pipeline
from analytics.assets import all_assets
from analytics.jobs.docs import generate_sf_scada_docs
from analytics.sensors.docs_sensor import trigger_generate_sf_scada_docs

# --- load the dbt manifest if it exists ---
manifest_path = Path(__file__).parent / "target" / "manifest.json"
if manifest_path.exists():
    manifest_json = json.loads(manifest_path.read_text())

    @dbt_assets(manifest=manifest_json)
    def dbt_project_assets():
        # decorator will collect your dbt nodes; return empty list
        return []

    dbt_asset_list = [dbt_project_assets]
else:
    dbt_asset_list = []

# --- define your “all assets” job if you still want it ---
all_assets_job = define_asset_job(
    name="all_assets_job",
    selection=AssetSelection.all(),
)

defs = Definitions(
    assets=[*all_assets, *dbt_asset_list],
    jobs=[
        scada_pipeline,
        all_assets_job,
        generate_sf_scada_docs,
    ],
    sensors=[trigger_generate_sf_scada_docs],
)
