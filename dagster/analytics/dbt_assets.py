# ~/scr/dagster/analytics/dbt_assets.py

from dagster_dbt import load_assets_from_dbt_project
from pathlib import Path

# ✅ Adjust these paths to match your actual DBT project layout
DBT_PROJECT_PATH = Path(__file__).joinpath("../../../dbt").resolve()
DBT_PROFILES_PATH = Path.home().joinpath(".dbt")

# ✅ This version works with dagster-dbt <= 0.21.x (and Dagster 1.10.x)
dbt_assets = load_assets_from_dbt_project(
    project_dir=str(DBT_PROJECT_PATH),
    profiles_dir=str(DBT_PROFILES_PATH)
)
