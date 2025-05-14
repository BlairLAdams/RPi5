from dagster import Definitions, load_assets_from_package_module
import analytics
from analytics.dbt_assets import dbt_assets

all_assets = load_assets_from_package_module(analytics)

defs = Definitions(
    assets=all_assets + dbt_assets,
)

