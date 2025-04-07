#!/bin/bash
#
# 📛 Filename: setupDagsterService.sh
# 📝 Description: Systemd service installer for Dagster dev UI on port 3300
# ⛓️ Depends on: Python virtualenv with Dagster installed, workspace.yaml, and repo
# 📂 Location: ~/scr
# 🧠 Notes: Assumes project is located in ~/dagster_proj
# ✅ Status: Production-ready

# ╭─────────────────────────────────────────────────────────────╮
# │ 💡 DEFINE SERVICE PARAMETERS                                │
# ╰─────────────────────────────────────────────────────────────╯
SERVICE_NAME="dagster"
PROJECT_DIR="/home/blair/dagster_proj"
VENV_PATH="$PROJECT_DIR/venv/bin/activate"
DAGSTER_COMMAND="dagster dev -h 0.0.0.0 -p 3300"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"

# ╭─────────────────────────────────────────────────────────────╮
# │ 🛑 EXIT IF NOT ROOT                                          │
# ╰─────────────────────────────────────────────────────────────╯
if [[ $EUID -ne 0 ]]; then
  echo "❌ This script must be run with sudo."
  exit 1
fi

# ╭─────────────────────────────────────────────────────────────╮
# │ 📄 CREATE SYSTEMD SERVICE FILE                              │
# ╰─────────────────────────────────────────────────────────────╯
echo "⚙️  Creating systemd service file for Dagster..."

cat > "$SERVICE_PATH" <<EOF
[Unit]
Description=Dagster Dev UI
After=network.target

[Service]
Type=simple
User=blair
WorkingDirectory=$PROJECT_DIR
ExecStart=/bin/bash -c 'source $VENV_PATH && $DAGSTER_COMMAND'
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# ╭─────────────────────────────────────────────────────────────╮
# │ 🔄 RELOAD SYSTEMD AND ENABLE SERVICE                        │
# ╰─────────────────────────────────────────────────────────────╯
echo "🔄 Reloading systemd, enabling, and starting $SERVICE_NAME..."
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl restart "$SERVICE_NAME"

# ╭─────────────────────────────────────────────────────────────╮
# │ 📋 VERIFY STATUS                                            │
# ╰─────────────────────────────────────────────────────────────╯
echo "📋 Checking status..."
systemctl status "$SERVICE_NAME" --no-pager

# 🎉 Done!
echo "✅ Dagster systemd service installed and running on port 3300."
