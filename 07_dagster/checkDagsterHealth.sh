#!/bin/bash
# checkDagsterHealth.sh

PORT=3300

if nc -z localhost $PORT; then
  echo "[OK] Dagster is responding on port $PORT"
else
  echo "[ERROR] Dagster is NOT responding on port $PORT"
  systemctl restart dagster
  echo "[INFO] Dagster service has been restarted."
fi
