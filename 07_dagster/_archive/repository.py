from .bronze_file_sensor import bronze_file_sensor, bronze_csv_ingest

@repository
def my_repo():
    return [bronze_csv_ingest, bronze_file_sensor]
