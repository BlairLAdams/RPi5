from dagster import asset

@asset
def silver_sf_scada():
    """
    Silver-layer SCADA asset. Applies QA checks and parses date/time fields.
    """
    pass
