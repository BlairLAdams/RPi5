from dagster import define_asset_job, AssetSelection

# Job to materialize only the docs-generation asset
# The variable name matches what repository.py imports
# The job name ends in _job to avoid naming collisions
# We select the asset key "generate_sf_scada_docs", which is the name of the @asset

generate_sf_scada_docs = define_asset_job(
    name="generate_sf_scada_docs_job",
    selection=AssetSelection.keys("generate_sf_scada_docs"),
)
