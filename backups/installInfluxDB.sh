#!/bin/bash
# installInfluxDB.sh
# Install InfluxDB on Raspberry Pi OS Lite (Debian-based)

set -e

# Add InfluxDB GPG key (updated for Debian 12 Bookworm compatibility)
curl -s https://repos.influxdata.com/influxdata-archive_compat.key | sudo gpg --dearmor -o /usr/share/keyrings/influxdb-archive-keyring.gpg

# Add InfluxDB repo
source /etc/os-release
echo "deb [signed-by=/usr/share/keyrings/influxdb-archive-keyring.gpg] https://repos.influxdata.com/${ID} ${VERSION_CODENAME} stable" \
  | sudo tee /etc/apt/sources.list.d/influxdb.list

# Install InfluxDB
sudo apt-get update
sudo apt-get install -y influxdb

# Enable and start service
sudo systemctl enable influxdb
sudo systemctl start influxdb

# Create initial bucket and user (for demo purposes)
INFLUX_SETUP=$(cat <<EOF
{
  "username": "demo",
  "password": "demo1234",
  "org": "demo-org",
  "bucket": "demo-bucket",
  "retention": "24h"
}
EOF
)
echo "$INFLUX_SETUP" > influx-setup.json

influx setup --skip-verify --force --config-name default \
  --username demo --password demo1234 \
  --org demo-org --bucket demo-bucket --retention 24h --token DEMO-TOKEN

# generateMetrics.py
# Simulates energy and water usage data for Grafana demo via InfluxDB

cat <<EOF > generateMetrics.py
#!/usr/bin/env python3
import random
import time
import requests
from datetime import datetime

INFLUX_URL = "http://localhost:8086/api/v2/write?org=demo-org&bucket=demo-bucket&precision=s"
INFLUX_TOKEN = "DEMO-TOKEN"

headers = {
    "Authorization": f"Token {INFLUX_TOKEN}",
    "Content-Type": "text/plain"
}

def generate_metrics():
    energy_kwh = round(random.uniform(100.0, 200.0), 2)
    water_liters = round(random.uniform(500.0, 1500.0), 1)
    efficiency = round(random.uniform(60.0, 95.0), 2)
    
    line = f"industrial_metrics total_energy_kwh={energy_kwh},total_water_liters={water_liters},efficiency_percent={efficiency}"
    response = requests.post(INFLUX_URL, headers=headers, data=line)
    if response.status_code != 204:
        print("Failed to write to InfluxDB:", response.text)

if __name__ == "__main__":
    while True:
        generate_metrics()
        time.sleep(10)
EOF

chmod +x generateMetrics.py

# grafanaDashboard.json
# Import this into Grafana via UI or API

cat <<EOF > grafanaDashboard.json
{
  "dashboard": {
    "id": null,
    "title": "Industrial Metrics Demo",
    "timezone": "browser",
    "panels": [
      {
        "type": "gauge",
        "title": "Efficiency %",
        "targets": [{
          "expr": "mean(\"efficiency_percent\")",
          "refId": "A"
        }],
        "fieldConfig": {
          "defaults": {
            "min": 0,
            "max": 100,
            "thresholds": {
              "mode": "absolute",
              "steps": [
                { "color": "red", "value": null },
                { "color": "orange", "value": 70 },
                { "color": "green", "value": 85 }
              ]
            }
          }
        },
        "gridPos": { "x": 0, "y": 0, "w": 8, "h": 6 }
      },
      {
        "type": "time_series",
        "title": "Energy Usage (kWh)",
        "targets": [{
          "expr": "mean(\"total_energy_kwh\")",
          "refId": "A"
        }],
        "gridPos": { "x": 0, "y": 6, "w": 12, "h": 6 }
      },
      {
        "type": "time_series",
        "title": "Water Usage (Liters)",
        "targets": [{
          "expr": "mean(\"total_water_liters\")",
          "refId": "A"
        }],
        "gridPos": { "x": 0, "y": 12, "w": 12, "h": 6 }
      }
    ],
    "schemaVersion": 36,
    "version": 1
  },
  "overwrite": true
}
EOF