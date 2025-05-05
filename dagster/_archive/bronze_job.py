#!/usr/bin/env python3
from dagster import job
from bronze_assets import bronze_ingest

@job
def bronze_job():
    bronze_ingest()
