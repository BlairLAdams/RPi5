from .wq_pipeline import load_bronze_wq, run_dbt
from .geocode_site_asset import geocode_site_coordinates

all_assets = [
    load_bronze_wq,
    run_dbt,
    geocode_site_coordinates
]

