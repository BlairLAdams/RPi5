from dagster import asset
import subprocess
import shutil
import os

@asset
def generate_dbt_docs():
    """
    Regenerates dbt docs from the project. Serves `dbt docs serve` externally.
    """
    dbt_dir = "/home/blair/scr/dagster/analytics"
    docs_dir = os.path.join(dbt_dir, "docs")
    target_dir = os.path.join(dbt_dir, "target")

    subprocess.run(["dbt", "docs", "generate"], cwd=dbt_dir, check=True)

    # Optional: keep docs around for inspection / fallback / archive
    if os.path.exists(docs_dir):
        shutil.rmtree(docs_dir)
    shutil.copytree(target_dir, docs_dir)
