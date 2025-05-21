from dagster import Definitions, define_asset_job, AssetSelection
from dagster_dbt import dbt_assets
from pathlib import Path
import json

from .pipelines.scada_pipeline import scada_pipeline

# Load compiled DBT manifest
manifest_path = Path(__file__).resolve().parent / "target" / "manifest.json"
if manifest_path.exists():
    with open(manifest_path) as f:
        manifest_json = json.load(f)
    has_nodes = "nodes" in manifest_json and manifest_json["nodes"]
else:
    manifest_json = {}
    has_nodes = False

# Only register dbt assets if there are nodes
if has_nodes:
    @dbt_assets(manifest=manifest_json)
    def dbt_project_assets():
        return []

    assets = [dbt_project_assets]
else:
    assets = []

# Define jobs
all_assets_job = define_asset_job("all_assets_job", selection=AssetSelection.all())

defs = Definitions(
    jobs=[scada_pipeline, all_assets_job],
    assets=assets,
)
