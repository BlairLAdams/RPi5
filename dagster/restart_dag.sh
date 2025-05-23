#!/usr/bin/env bash
#
# restart_dag.sh — Restart Dagster daemon and web UI only
# Author:   Blair | Updated: 2025-05-22
#

set -Eeuo pipefail
IFS=$'\n\t'

### Configuration ###
readonly DAGSTER_HOME="$HOME/scr/dagster/.dagster_home"
readonly VENV_ACTIVATE="$HOME/scr/dagster/venv/bin/activate"
readonly ANALYTICS_DIR="$HOME/scr/dagster"
readonly LOGFILE="$ANALYTICS_DIR/dagster.log"
readonly DAGSTER_PORT=3300

### Error handler ###
error_exit() {
  echo "❌ [restart_dagster.sh] Error on line $1"
  exit 1
}
trap 'error_exit $LINENO' ERR

### Logging helper ###
log() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"
}

kill_existing() {
  log "🔄 Killing existing Dagster processes..."
  pkill -f "dagster-webserver"   || true
  pkill -f "dagster-daemon"      || true
  pkill -f "dagster dev"         || true
  lsof -ti:"$DAGSTER_PORT"       \
    | xargs -r kill -9           || true
}

activate_venv() {
  if [[ -f "$VENV_ACTIVATE" ]]; then
    log "🐍 Activating virtualenv..."
    # shellcheck disable=SC1090
    source "$VENV_ACTIVATE"
  else
    echo "❌ [restart_dagster.sh] Virtualenv not found at $VENV_ACTIVATE"
    exit 1
  fi
}

load_dbt_creds() {
  log "🔐 Loading DBT credentials from pass..."
  # you can override DBT_USER in your env if needed
  export DBT_USER="${DBT_USER:-blair}"
  export DBT_PASS="$(pass dbt/postgres/blair)"
  export PGPASSWORD="$DBT_PASS"
  log "✔️  DBT_USER=${DBT_USER}"
}

prepare_home() {
  log "🔧 Ensuring DAGSTER_HOME exists at $DAGSTER_HOME"
  mkdir -p "$DAGSTER_HOME"
}

start_daemon() {
  log "🚀 Launching dagster-daemon..."
  cd "$ANALYTICS_DIR"
  nohup dagster-daemon run >> "$LOGFILE" 2>&1 &
}

start_web() {
  log "🌐 Launching dagster-webserver on port $DAGSTER_PORT..."
  nohup dagster dev -m analytics -p "$DAGSTER_PORT" >> "$LOGFILE" 2>&1 &
}

show_status() {
  sleep 2
  log "✅ Dagster UI: http://127.0.0.1:$DAGSTER_PORT"
  log "📄 Logs: $LOGFILE"
}

main() {
  kill_existing
  activate_venv
  load_dbt_creds
  prepare_home
  start_daemon
  start_web
  show_status
}

main "$@"
