#!/bin/bash
# loadMetabaseFullSample.sh
# Clones and loads the full official-style Metabase sample dataset into PostgreSQL

set -e

echo "[*] Cloning the full Metabase sample dataset repo..."
git clone https://github.com/aeosynth/metabase-sample-dataset.git /tmp/metabase-sample-dataset

echo "[*] Loading dataset into PostgreSQL (sampledb)..."
PGPASSWORD=metabase psql -U metabase -h localhost -d sampledb -f /tmp/metabase-sample-dataset/sample-dataset.sql

echo "[*] Done! The full tutorial dataset is now loaded into PostgreSQL."
echo "Open Metabase and connect to 'sampledb' to begin exploring."
