#!/bin/bash
#
# setupFirewallAndRestart.sh
# Enables necessary firewall ports and restarts monitoring services.
#
# Useful checks:
#   sudo ufw status
#   sudo ufw enable

echo "[INFO] Configuring UFW firewall rules..."

# Drop existing firewall rules before re-adding them to avoid duplicates
sudo ufw delete allow 22/tcp     comment 'Allow SSH'
sudo ufw delete allow 3000/tcp   comment 'Allow Grafana'
sudo ufw delete allow 9090/tcp   comment 'Allow Prometheus'
sudo ufw delete allow 3030/tcp   comment 'Allow Metabase'
sudo ufw delete allow 8080/tcp   comment 'Allow DBT Docs'
sudo ufw delete allow 5432/tcp   comment 'Allow PostgreSQL'
sudo ufw delete allow 3001/tcp   comment 'Allow Dagster'

# Allow core services
sudo ufw allow 22/tcp     comment 'Allow SSH (used for secure shell access)'
sudo ufw allow 3000/tcp   comment 'Allow Grafana (used for data visualization platform)'
sudo ufw allow 9090/tcp   comment 'Allow Prometheus (used for monitoring and alerting)'
sudo ufw allow 3030/tcp   comment 'Allow Metabase (used for business intelligence and data analysis)'
sudo ufw allow 8080/tcp   comment 'Allow DBT Docs (used for serving dbt project documentation)'
sudo ufw allow 5432/tcp   comment 'Allow PostgreSQL (used for database access)'
sudo ufw allow 3001/tcp   comment 'Allow Dagster (used for orchestrating data workflows)'

# Reload firewall rules to apply changes
sudo ufw reload

echo "[INFO] Restarting monitoring services..."

# Restart core services
sudo systemctl restart grafana-server     comment 'Restart Grafana service'
sudo systemctl restart prometheus         comment 'Restart Prometheus service'
sudo systemctl restart metabase           comment 'Restart Metabase service'
sudo systemctl restart postgresql         comment 'Restart PostgreSQL service'
sudo systemctl restart dagster           comment 'Restart Dagster service'

# Refresh the firewall and check status
sudo ufw reload
sudo ufw status verbose

echo "[SUCCESS] Firewall configured and services restarted. Status updated."
