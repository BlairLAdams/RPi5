#!/bin/bash

###############################################################################
# restart_dbt.sh — Restart DBT Docs on Port 8080
# Author: Blair | Updated: 2025-05-21
###############################################################################

set -e

VENV_PATH="$HOME/scr/dagster/venv"
DBT_PROJECT_DIR="$HOME/scr/dagster/analytics"
DBT_DOCS_PORT=8080
LOGFILE="$DBT_PROJECT_DIR/dbt-docs.log"

echo "[restart_dbtdocs.sh] 🔁 Restarting DBT Docs on port $DBT_DOCS_PORT..."

# ✅ Activate virtual environment
if [ -f "$VENV_PATH/bin/activate" ]; then
  source "$VENV_PATH/bin/activate"
  echo "[restart_dbtdocs.sh] 🧪 Activated venv at $VENV_PATH"
else
  echo "[restart_dbtdocs.sh] ❌ Could not find venv at $VENV_PATH"
  exit 1
fi

# ✅ Kill lingering processes
pkill -f "dbt docs serve" || true
pkill -f "http.server" || true
lsof -ti:$DBT_DOCS_PORT | xargs -r kill -9 || true

# ✅ Confirm port is free
if lsof -i :$DBT_DOCS_PORT | grep LISTEN; then
  echo "[restart_dbtdocs.sh] ❌ Port $DBT_DOCS_PORT still in use."
  exit 1
fi

# ✅ Launch DBT Docs
cd "$DBT_PROJECT_DIR" || exit 1
echo "[restart_dbtdocs.sh] 🚀 Launching dbt docs serve..."
nohup dbt docs serve --port "$DBT_DOCS_PORT" >> "$LOGFILE" 2>&1 &
sleep 2

# ✅ Check status
if curl --silent --fail "http://127.0.0.1:$DBT_DOCS_PORT" >/dev/null; then
  echo "[restart_dbtdocs.sh] ✅ DBT Docs is live at http://localhost:$DBT_DOCS_PORT"
else
  echo "[restart_dbtdocs.sh] ❌ DBT Docs failed to start. Check $LOGFILE"
  tail -n 10 "$LOGFILE"
fi
