#!/bin/bash
# run_bronze2silver_sf.sh

echo "🔁 Running SCADA QA load..."
psql -U blair -d analytics -f bronze2silver_sf_scada.sql

echo "🔁 Running CMMS QA load..."
psql -U blair -d analytics -f bronze2silver_sf_cmms.sql

echo "🔁 Running LIMS QA load..."
psql -U blair -d analytics -f bronze2silver_sf_lims.sql
