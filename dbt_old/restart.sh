#!/bin/bash

###############################################################################
# ⚙️ restart.sh — Manage dbt-docs as a systemd service
#
# Supports:
#   --force-restart : Kills and restarts the dbt-docs service
#   --status-only   : Displays service and HTTP status without restarting
#
# Default behavior:
#   Reloads systemd, starts the service, checks status and confirms HTTP
###############################################################################

SERVICE_NAME="dbt-docs"
CHECK_URL="http://localhost:8080"
USE_HTTPS="https://dbt.hoveto.ca"

print_status() {
  echo "📋 Checking systemd status for $SERVICE_NAME..."
  sudo systemctl status "$SERVICE_NAME" --no-pager --lines=5
  echo
  echo "🌐 Verifying local HTTP response at $CHECK_URL..."
  if curl -s --head "$CHECK_URL" | grep "200 OK" > /dev/null; then
    echo "✅ $SERVICE_NAME is responding at $CHECK_URL"
  elif curl -s --head "$USE_HTTPS" | grep "200 OK" > /dev/null; then
    echo "✅ $SERVICE_NAME is live at $USE_HTTPS (via Nginx)"
  else
    echo "❌ $SERVICE_NAME is not responding on $CHECK_URL or $USE_HTTPS"
    echo "💡 Check logs: journalctl -u $SERVICE_NAME -f"
    exit 1
  fi
}

case "$1" in
  --force-restart)
    echo "🔁 Force restarting $SERVICE_NAME..."
    sudo systemctl daemon-reexec
    sudo systemctl daemon-reload
    sudo systemctl restart "$SERVICE_NAME"
    sleep 3
    print_status
    ;;
  --status-only)
    print_status
    ;;
  *)
    echo "🔄 Reloading systemd and starting $SERVICE_NAME..."
    sudo systemctl daemon-reexec
    sudo systemctl daemon-reload
    sudo systemctl start "$SERVICE_NAME"
    sleep 3
    print_status
    ;;
esac
