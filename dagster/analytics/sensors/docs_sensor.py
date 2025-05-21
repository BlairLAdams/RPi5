from dagster import asset_sensor, AssetKey, RunRequest, DefaultSensorStatus

@asset_sensor(
    asset_key=AssetKey("gold_sf_scada"),
    name="trigger_generate_docs_after_gold",
    default_status=DefaultSensorStatus.RUNNING,
)
def generate_docs_sensor(context):
    return RunRequest(
        run_key=None,
        run_config={},  # Empty because all config is baked into assets
        job_name="generate_docs_job"
    )
