#!/bin/bash
# ✅ Filename: setupGrafanaDatasource.sh
# 📦 Purpose: Configure Prometheus as a Grafana data source and load a deluxe dashboard
# 🧠 Style: Full PiosHarden comments, gauges + graphs, secure prompt

# ─────────────────────────────────────────────────────────────────────────────
# 🔐 STEP 0: PROMPT FOR ADMIN PASSWORD
# ─────────────────────────────────────────────────────────────────────────────
read -s -p "🔑 Enter Grafana admin password: " grafana_pw
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# 📥 STEP 1: WAIT FOR GRAFANA TO RESPOND
# ─────────────────────────────────────────────────────────────────────────────
echo "📥 Waiting for Grafana to be accessible on port 3000..."
for i in {1..12}; do
  if curl -s --head http://localhost:3000 | grep -q "HTTP/1.1"; then
    echo "✅ Grafana is up!"
    break
  else
    echo "⏳ Waiting for Grafana..."
    sleep 5
  fi
done

# ─────────────────────────────────────────────────────────────────────────────
# 📡 STEP 2: CREATE PROMETHEUS DATA SOURCE
# ─────────────────────────────────────────────────────────────────────────────
echo "📡 Creating Prometheus data source..."

DATA_SOURCE_JSON=$(cat <<EOF
{
  "name": "Prometheus",
  "type": "prometheus",
  "access": "proxy",
  "url": "http://localhost:9090",
  "basicAuth": false,
  "isDefault": true
}
EOF
)

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -u admin:$grafana_pw \
  -d "${DATA_SOURCE_JSON}" \
  http://localhost:3000/api/datasources)

if [ "$RESPONSE" -eq 200 ] || [ "$RESPONSE" -eq 409 ]; then
  echo "✅ Prometheus data source created (HTTP code: $RESPONSE)."
else
  echo "❌ Failed to create data source (HTTP code: $RESPONSE)."
  exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# 📊 STEP 3: IMPORT DELUXE MULTI-PANEL DASHBOARD
# ─────────────────────────────────────────────────────────────────────────────
echo "📊 Importing deluxe Grafana dashboard..."

DASHBOARD_JSON=$(cat <<'EOF'
{
  "dashboard": {
    "id": null,
    "uid": "rpi-deluxe",
    "title": "Raspberry Pi Deluxe Monitor",
    "tags": ["system", "node_exporter", "rpi"],
    "timezone": "browser",
    "schemaVersion": 36,
    "version": 1,
    "refresh": "10s",
    "panels": [
      {
        "type": "row",
        "title": "System Gauges",
        "gridPos": { "x": 0, "y": 0, "w": 24, "h": 1 },
        "collapsed": false,
        "panels": [
          {
            "type": "gauge",
            "title": "CPU Usage (%)",
            "gridPos": { "x": 0, "y": 1, "w": 8, "h": 5 },
            "targets": [
              {
                "expr": "100 - (avg by(instance)(irate(node_cpu_seconds_total{mode='idle'}[5m])) * 100)",
                "refId": "A"
              }
            ],
            "fieldConfig": {
              "defaults": {
                "unit": "percent",
                "max": 100,
                "thresholds": {
                  "mode": "percentage",
                  "steps": [
                    { "color": "green", "value": null },
                    { "color": "orange", "value": 70 },
                    { "color": "red", "value": 90 }
                  ]
                }
              }
            }
          },
          {
            "type": "gauge",
            "title": "Memory Usage (%)",
            "gridPos": { "x": 8, "y": 1, "w": 8, "h": 5 },
            "targets": [
              {
                "expr": "(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100",
                "refId": "A"
              }
            ],
            "fieldConfig": {
              "defaults": {
                "unit": "percent",
                "max": 100,
                "thresholds": {
                  "mode": "percentage",
                  "steps": [
                    { "color": "green", "value": null },
                    { "color": "orange", "value": 70 },
                    { "color": "red", "value": 90 }
                  ]
                }
              }
            }
          },
          {
            "type": "gauge",
            "title": "Disk Usage (%)",
            "gridPos": { "x": 16, "y": 1, "w": 8, "h": 5 },
            "targets": [
              {
                "expr": "(node_filesystem_size_bytes{mountpoint='/'} - node_filesystem_free_bytes{mountpoint='/'}) / node_filesystem_size_bytes{mountpoint='/'} * 100",
                "refId": "A"
              }
            ],
            "fieldConfig": {
              "defaults": {
                "unit": "percent",
                "max": 100,
                "thresholds": {
                  "mode": "percentage",
                  "steps": [
                    { "color": "green", "value": null },
                    { "color": "orange", "value": 70 },
                    { "color": "red", "value": 90 }
                  ]
                }
              }
            }
          }
        ]
      },
      {
        "type": "timeseries",
        "title": "Load Average (1m)",
        "gridPos": { "x": 0, "y": 6, "w": 12, "h": 6 },
        "targets": [
          {
            "expr": "node_load1",
            "refId": "A"
          }
        ]
      },
      {
        "type": "timeseries",
        "title": "Network I/O - eth0",
        "gridPos": { "x": 12, "y": 6, "w": 12, "h": 6 },
        "targets": [
          {
            "expr": "rate(node_network_receive_bytes_total{device='eth0'}[1m])",
            "legendFormat": "receive",
            "refId": "A"
          },
          {
            "expr": "rate(node_network_transmit_bytes_total{device='eth0'}[1m])",
            "legendFormat": "transmit",
            "refId": "B"
          }
        ]
      },
      {
        "type": "stat",
        "title": "Uptime",
        "gridPos": { "x": 0, "y": 12, "w": 6, "h": 4 },
        "targets": [
          {
            "expr": "node_time_seconds - node_boot_time_seconds",
            "refId": "A"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "s",
            "decimals": 0
          }
        }
      }
    ]
  },
  "overwrite": true
}
EOF
)

RESPONSE_DASH=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -u admin:$grafana_pw \
  -d "$DASHBOARD_JSON" \
  http://localhost:3000/api/dashboards/db)

if [ "$RESPONSE_DASH" -eq 200 ] || [ "$RESPONSE_DASH" -eq 412 ]; then
  echo "✅ Dashboard imported successfully (HTTP code: $RESPONSE_DASH)."
else
  echo "❌ Failed to import dashboard (HTTP code: $RESPONSE_DASH)"
  exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 4: DONE
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Grafana now includes the deluxe Raspberry Pi system dashboard."
echo "🔗 Open: http://$(hostname -I | cut -d' ' -f1):3000"
