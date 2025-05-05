#!/bin/bash
#
# 📛 Filename: setupFirewallAndRestart.sh
# 🛡️ Description: Configures UFW firewall rules and restarts monitoring services.
# 🔐 Use with caution on headless Pi — ensure SSH (port 22) is always allowed.
# 📂 Location: ~/scr
# ✅ Status: Production-ready

# ╭─────────────────────────────────────────────────────────────╮
# │ 🛑 SAFETY CHECK: Must be run as root                        │
# ╰─────────────────────────────────────────────────────────────╯
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run this script with sudo."
  exit 1
fi

# ╭─────────────────────────────────────────────────────────────╮
# │ 🔧 UFW RULE RESET                                           │
# ╰─────────────────────────────────────────────────────────────╯
echo "🧱 [INFO] Cleaning up existing UFW rules..."

for PORT in 22 3000 9090 3300 8080 5432 3001; do
  sudo ufw delete allow "${PORT}/tcp" 2>/dev/null || true
done

# ╭─────────────────────────────────────────────────────────────╮
# │ 🔓 ADD FRESH UFW RULES                                      │
# ╰─────────────────────────────────────────────────────────────╯
echo "🔓 [INFO] Adding required UFW rules..."

sudo ufw allow 22/tcp    comment 'Allow SSH'
sudo ufw allow 3000/tcp  comment 'Allow Grafana'
sudo ufw allow 9090/tcp  comment 'Allow Prometheus'
sudo ufw allow 3300/tcp  comment 'Allow Dagster'
sudo ufw allow 8080/tcp  comment 'Allow DBT Docs'
sudo ufw allow 5432/tcp  comment 'Allow PostgreSQL'
sudo ufw allow 3001/tcp  comment 'Allow Metabase'
sudo ufw allow 5001/tcp  comment 'Alertmanager webhook receiver'

sudo ufw reload

# ╭─────────────────────────────────────────────────────────────╮
# │ 🔄 SERVICE RESTART SECTION                                  │
# ╰─────────────────────────────────────────────────────────────╯
echo "🔁 [INFO] Restarting monitoring and data services..."

for SERVICE in grafana-server prometheus metabase postgresql dagster; do
  echo "⏳ Restarting $SERVICE..."
  sudo systemctl restart "$SERVICE" || echo "⚠️  Warning: Service $SERVICE failed to restart"
done

# ╭─────────────────────────────────────────────────────────────╮
# │ ✅ FINAL VERIFICATION                                       │
# ╰─────────────────────────────────────────────────────────────╯
echo "📋 [INFO] Firewall status:"
sudo ufw status verbose

echo "✅ [SUCCESS] Firewall configured and services restarted."
