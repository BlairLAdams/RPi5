#!/bin/bash

# Set error handling
set -eo pipefail

# Define functions for stopping services
stop_service() {
    service_name=$1
    echo "Stopping $service_name if running..."
    sudo systemctl stop "$service_name" 2>/dev/null || true
}

# Install system packages
echo "Installing system packages..."
sudo apt update
sudo apt install -y wget curl software-properties-common apt-transport-https jq libcap2-bin

# Prometheus and Node Exporter installation
echo "Installing Prometheus and Node Exporter..."
sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus || true
sudo mkdir -p /etc/prometheus /var/lib/prometheus
PROM_VER="2.52.0"
NODE_EXPORTER_VER="1.8.1"

# Install Prometheus
wget "https://github.com/prometheus/prometheus/releases/download/v$PROM_VER/prometheus-$PROM_VER.linux-armv7.tar.gz"
tar xvf "prometheus-$PROM_VER.linux-armv7.tar.gz"
cd "prometheus-$PROM_VER.linux-armv7"
stop_service prometheus
sudo cp prometheus promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/prometheus
sudo cp -r consoles console_libraries /etc/prometheus/
cd ..
rm -rf "prometheus-$PROM_VER.linux-armv7*"

# Install Node Exporter
wget "https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VER/node_exporter-$NODE_EXPORTER_VER.linux-armv7.tar.gz"
tar xvf "node_exporter-$NODE_EXPORTER_VER.linux-armv7.tar.gz"
cd "node_exporter-$NODE_EXPORTER_VER.linux-armv7"
stop_service node_exporter
sudo cp node_exporter /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/node_exporter
cd ..
rm -rf "node_exporter-$NODE_EXPORTER_VER.linux-armv7*"
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Configure Prometheus
echo "Configuring Prometheus..."
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
EOF

# Systemd service setup for Prometheus and Node Exporter
echo "Setting up systemd services..."
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/ --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries
Restart=always
[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target
[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter
Restart=always
[Install]
WantedBy=default.target
EOF

# Start and enable services
echo "Starting Prometheus and Node Exporter..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus node_exporter
sudo systemctl start prometheus node_exporter

# Grafana installation
echo "Removing any existing Grafana installations..."
sudo systemctl stop grafana-server 2>/dev/null || true
sudo systemctl disable grafana-server 2>/dev/null || true
sudo apt remove --purge -y grafana || true
sudo apt autoremove -y
sudo rm -rf /etc/grafana /var/lib/grafana /usr/share/grafana /etc/systemd/system/grafana-server.service

echo "Installing Grafana..."
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://packages.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
echo "Waiting for Grafana to start..."
sleep 15

# Grafana datasource provisioning
echo "Provisioning Prometheus datasource..."
sudo mkdir -p /etc/grafana/provisioning/datasources
sudo tee /etc/grafana/provisioning/datasources/prometheus.yaml > /dev/null <<EOF
apiVersion: 1
datasources:
- name: Prometheus
  type: prometheus
  access: proxy
  url: http://localhost:9090
  isDefault: true
EOF

# Grafana dashboard installation
echo "Installing Node Exporter Full dashboard..."
DASHBOARD_DIR=~/scr/grafana_dashboards
mkdir -p "$DASHBOARD_DIR"
DASHBOARD_URL="https://grafana.com/api/dashboards/1860/revisions/32/download"
DASHBOARD_JSON="$DASHBOARD_DIR/node_exporter_full.json"
wget -qO "$DASHBOARD_JSON" "$DASHBOARD_URL"
if jq -e '.dashboard' "$DASHBOARD_JSON" > /dev/null; then
  DASH_PAYLOAD=$(jq '.dashboard' "$DASHBOARD_JSON")
else
  DASH_PAYLOAD=$(cat "$DASHBOARD_JSON")
fi
curl -s -X POST http://localhost:3000/api/dashboards/db \
  -H "Content-Type: application/json" \
  -u admin:admin \
  -d @- <<EOF
{
  "dashboard": $DASH_PAYLOAD,
  "overwrite": true,
  "folderId": 0,
  "message": "Imported by grafanaDemoInstall"
}
EOF

echo "Grafana demo stack is live!"
echo "Open in browser: http://<your-pi-ip>:3000"
echo "Login: admin / admin"
echo "Dashboard: 'Node Exporter Full' (with real-time Pi metrics)"