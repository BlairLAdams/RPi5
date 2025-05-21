from dagster import asset

@asset
def gold_sf_scada():
    """
    Gold-layer SCADA asset. Joins and transforms data into final observation mart.
    """
    pass
