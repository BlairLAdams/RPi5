#!/bin/bash
# importLokiDashboard.sh - Automatically imports a Grafana Loki dashboard using the correct data source

GRAFANA_URL="http://localhost:3000"
DASHBOARD_ID="13639"

# Prompt for Grafana admin credentials
read -p "Grafana Username: " USERNAME
read -s -p "Grafana Password: " PASSWORD
echo ""

echo "[INFO] Connecting to Grafana API to look up Loki data source..."

# Make the API request and capture HTTP status separately
RESPONSE=$(curl -s -w "%{http_code}" -u "${USERNAME}:${PASSWORD}" "${GRAFANA_URL}/api/datasources" -o /tmp/grafana-ds.json)

if [[ "$RESPONSE" != "200" ]]; then
  echo "[ERROR] Failed to connect to Grafana API (HTTP $RESPONSE)."
  echo "Here’s what came back:"
  cat /tmp/grafana-ds.json | head -n 10
  exit 1
fi

DATASOURCE_NAME=$(jq -r '.[] | select(.type=="loki") | .name' /tmp/grafana-ds.json | head -n 1)

if [[ -z "$DATASOURCE_NAME" ]]; then
  echo "[ERROR] No Loki data source found in Grafana. Please add one first."
  exit 1
fi

echo "[INFO] Using detected Loki data source: '$DATASOURCE_NAME'"

echo "[INFO] Downloading dashboard JSON from Grafana.com..."
curl -s "https://grafana.com/api/dashboards/${DASHBOARD_ID}/revisions/latest/download" -o /tmp/loki-dashboard.json

if ! grep -q '"__inputs"' /tmp/loki-dashboard.json; then
  echo "[WARN] Dashboard does not declare __inputs — patching may not be necessary."
fi

echo "[INFO] Importing dashboard into Grafana..."
curl -s -X POST "${GRAFANA_URL}/api/dashboards/import" \
  -u "${USERNAME}:${PASSWORD}" \
  -H "Content-Type: application/json" \
  -d @<(cat <<EOF
{
  "dashboard": $(cat /tmp/loki-dashboard.json),
  "overwrite": true,
  "inputs": [
    {
      "name": "DS_LOKI",
      "type": "datasource",
      "pluginId": "loki",
      "value": "${DATASOURCE_NAME}"
    }
  ]
}
EOF
)

echo "[SUCCESS] Dashboard imported and linked to: '${DATASOURCE_NAME}'"
