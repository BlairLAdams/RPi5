#!/bin/bash
# enableDbtDocsOnBoot.sh
# ============================================================
# Configures dbt docs web UI to run on boot via systemd.
# Author: Blair
#
# Description:
#   - Creates systemd unit file for dbt docs serve
#   - Ensures logs and port 8080 access
#   - Enables and starts the service
#
# Tasks:
#   ✅ Create /etc/systemd/system/dbt-docs.service
#   ✅ Allow UFW port 8080
#   ✅ Create log directory
#   ✅ Reload systemd + enable service
# ============================================================

set -e

SERVICE_FILE="/etc/systemd/system/dbt-docs.service"
WORK_DIR="/home/blair/scr/duckdemo"
EXEC_PATH="$HOME/.local/bin/dbt"
LOG_DIR="$HOME/scr/logs"

echo "📁 Ensuring log directory exists..."
mkdir -p "$LOG_DIR"

echo "🛡 Allowing UFW port 8080 if not already open..."
sudo ufw allow 8080

echo "🛠 Creating systemd unit file..."
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=DBT Docs Web Server
After=network.target

[Service]
Type=simple
User=blair
WorkingDirectory=$WORK_DIR
ExecStart=$EXEC_PATH docs serve --port 8080 --no-browser
Restart=always
RestartSec=5
StandardOutput=append:$LOG_DIR/dbt-docs.log
StandardError=append:$LOG_DIR/dbt-docs.err

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 Reloading systemd and enabling service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable dbt-docs.service
sudo systemctl restart dbt-docs.service

echo "✅ DBT Docs service installed and running."
echo "🔍 To check status: systemctl status dbt-docs.service"
echo "🌐 Visit http://<pi-ip>:8080 to view your docs."