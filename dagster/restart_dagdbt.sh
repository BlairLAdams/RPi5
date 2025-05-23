#!/bin/bash

###############################################################################
# restart_dagdbt.sh — Restart Dagster & DBT Docs (w/ Static Fallback)
# Author: Blair | Updated: 2025-05-21
###############################################################################

LOGFILE="$HOME/scr/dagster/dagster.log"
PIDFILE_DAEMON="$HOME/scr/dagster/dagster-daemon.pid"
PIDFILE_WEBSERVER="$HOME/scr/dagster/dagster-webserver.pid"
PIDFILE_DBT_DOCS="$HOME/scr/dagster/dbt-docs.pid"
DAGSTER_HOME="$HOME/scr/dagster/.dagster_home"
VENV_ACTIVATE="$HOME/scr/dagster/venv/bin/activate"
ANALYTICS_DIR="$HOME/scr/dagster"
DBT_PROJECT_DIR="$HOME/scr/dagster/analytics"
DBT_DOCS_PORT=8080
DAGSTER_PORT=3300

echo "[restart.sh] 🔁 Cleaning up..."
echo "[restart.sh] 🗂️  Using DAGSTER_HOME: $DAGSTER_HOME"

# ✅ Kill anything lingering
pkill -f "dbt docs serve" || true
pkill -f "python.*http.server" || true
pkill -f "dagster-webserver" || true
pkill -f "dagster-daemon" || true
pkill -f "dagster dev" || true
lsof -ti:"$DBT_DOCS_PORT" | xargs -r kill -9 || true
lsof -ti:"$DAGSTER_PORT" | xargs -r kill -9 || true

# 🔄 Allow ports to free
sleep 1

# ✅ Optionally reset metadata
if [ "$RESET_DAGSTER_HOME" = "true" ]; then
  echo "[restart.sh] ⚠️  Resetting Dagster instance..."
  rm -rf "$DAGSTER_HOME"
  mkdir -p "$DAGSTER_HOME"
  touch "$DAGSTER_HOME/dagster.yaml"
fi

# ✅ Ensure instance directory exists
mkdir -p "$DAGSTER_HOME"

# 🔄 Rotate existing log (optional, lightweight)
if [ -f "$LOGFILE" ]; then
  mv "$LOGFILE" "$LOGFILE.$(date +%Y%m%d_%H%M%S)"
fi

rm -f "$PIDFILE_DAEMON" "$PIDFILE_WEBSERVER" "$PIDFILE_DBT_DOCS"

# ✅ Activate venv
if [ -f "$VENV_ACTIVATE" ]; then
  source "$VENV_ACTIVATE"
else
  echo "[restart.sh] ❌ Venv not found: $VENV_ACTIVATE"
  exit 1
fi

# ✅ Load DBT credentials
export DBT_USER=blair
export DBT_PASSWORD=$(pass dbt/postgres/blair)
export PGPASSWORD="$DBT_PASSWORD"
echo "[restart.sh] 🔍 Loaded DBT_USER=$DBT_USER and DBT_PASSWORD=${#DBT_PASSWORD} chars"

# ✅ Generate docs
cd "$DBT_PROJECT_DIR" || exit 1
rm -rf target/

dbt compile || { echo "[restart.sh] ❌ dbt compile failed"; exit 1; }
dbt docs generate || { echo "[restart.sh] ❌ dbt docs generate failed"; exit 1; }

# ✅ Check for manifest.json existence
if [ ! -s target/manifest.json ]; then
  echo "[restart.sh] ❌ DBT docs generation failed: manifest.json missing or empty"
  exit 1
fi

# ✅ Try to serve docs with Flask
echo "[restart.sh] 📚 Attempting to launch dbt-docs via Flask..."
nohup dbt docs serve --port "$DBT_DOCS_PORT" >> "$LOGFILE" 2>&1 &
DOCS_PID=$!

# ✅ Wait up to 10 seconds for Flask to respond
for i in {1..10}; do
  if curl --silent --fail "http://127.0.0.1:$DBT_DOCS_PORT" >/dev/null; then
    echo "[restart.sh] ✅ Flask dbt-docs is running on port $DBT_DOCS_PORT"
    echo $DOCS_PID > "$PIDFILE_DBT_DOCS"
    break
  fi
  sleep 1
done

# ✅ Fallback to static mode if Flask failed
if ! curl --silent --fail "http://127.0.0.1:$DBT_DOCS_PORT" >/dev/null; then
  echo "[restart.sh] ❌ Flask dbt-docs failed, falling back to static mode..."
  pkill -f "dbt docs serve" || true
  cd target || exit 1
  nohup python3 -m http.server "$DBT_DOCS_PORT" >> "$LOGFILE" 2>&1 &
  echo $! > "$PIDFILE_DBT_DOCS"

  # Final check to verify static server
  if curl --silent --fail "http://127.0.0.1:$DBT_DOCS_PORT" >/dev/null; then
    echo "[restart.sh] ✅ Static DBT docs server is now running."
  else
    echo "[restart.sh] ⚠️  Static DBT docs server failed to respond."
  fi
fi

# ✅ Launch Dagster daemon
echo "[restart.sh] 🚀 Launching dagster-daemon..."
cd "$ANALYTICS_DIR" || exit 1
DAGSTER_HOME="$DAGSTER_HOME" nohup dagster-daemon run >> "$LOGFILE" 2>&1 &
echo $! > "$PIDFILE_DAEMON"

# ✅ Launch Dagster UI
echo "[restart.sh] 🌐 Launching dagster-webserver on port $DAGSTER_PORT..."
DAGSTER_HOME="$DAGSTER_HOME" nohup dagster dev -m analytics -p "$DAGSTER_PORT" >> "$LOGFILE" 2>&1 &
echo $! > "$PIDFILE_WEBSERVER"

# ✅ Show status
sleep 2
echo "[restart.sh] ✅ Dagster UI: http://127.0.0.1:$DAGSTER_PORT"
echo "[restart.sh] ✅ DBT Docs:   http://127.0.0.1:$DBT_DOCS_PORT"
echo "📄 Logs: $LOGFILE"
