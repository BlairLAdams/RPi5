from dagster import asset_sensor, AssetKey, RunRequest, DefaultSensorStatus

@asset_sensor(
    asset_key=AssetKey("gold_sf_scada"),
    name="trigger_generate_sf_scada_docs",
    job_name="generate_sf_scada_docs_job",
    default_status=DefaultSensorStatus.STOPPED,
)
def trigger_generate_sf_scada_docs(context):
    return RunRequest(
        run_key=None,
        run_config={},
    )
