#!/bin/bash

# ┌─────────────────────────────────────────────┐
# │  restart.sh — MkDocs Background Web Server  │
# └─────────────────────────────────────────────┘
#
# This script:
#   ✅ Kills any process using the configured port
#   ✅ Activates the MkDocs virtual environment
#   ✅ Starts MkDocs as a background job (logs output)
#
# Usage:
#   ./restart.sh
#
# Logs:
#   ~/scr/mkdocs/mkdocs.log
#
# Stop with:
#   kill $(cat ~/scr/mkdocs/mkdocs.pid)
#
# ----------------------------------------------

VENV="$HOME/scr/mkdocs/venv"
PROJECT_DIR="$HOME/scr/mkdocs"
PORT=8004
LOGFILE="$PROJECT_DIR/mkdocs.log"
PIDFILE="$PROJECT_DIR/mkdocs.pid"

echo "[restart.sh] 🔁 Restarting MkDocs on port $PORT..."

# ✅ Kill any process currently using the desired port
fuser -k ${PORT}/tcp 2>/dev/null

# ✅ Activate virtual environment and navigate to project
source "$VENV/bin/activate"
cd "$PROJECT_DIR"

# ✅ Start MkDocs as a background job with logging
nohup mkdocs serve -a "0.0.0.0:$PORT" > "$LOGFILE" 2>&1 &

# ✅ Save the PID for later control
echo $! > "$PIDFILE"

echo "[restart.sh] ✅ MkDocs started on http://<your-pi-ip>:$PORT"
echo "[restart.sh] 📄 Logs: $LOGFILE"
