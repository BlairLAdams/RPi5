#!/bin/bash
#
# setupFirewallAndRestart.sh
# Enables necessary firewall ports and restarts monitoring services.
#
# Useful checks:
#   sudo ufw status
#   sudo ufw enable

echo "[INFO] Configuring UFW firewall rules..."

# Allow core services
sudo ufw allow 22/tcp     comment 'Allow SSH'
sudo ufw allow 3000/tcp   comment 'Allow Grafana'
sudo ufw allow 9090/tcp   comment 'Allow Prometheus'
sudo ufw allow 3030/tcp   comment 'Allow Metabase'

# Reload firewall rules
sudo ufw reload

echo "[INFO] Restarting monitoring services..."

# Restart core services
sudo systemctl restart grafana-server
sudo systemctl restart prometheus
sudo systemctl restart metabase

echo "[SUCCESS] Firewall configured and services restarted."
