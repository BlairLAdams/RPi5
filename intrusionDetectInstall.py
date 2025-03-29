# Combined script for installing Fail2Ban, Promtail, Loki, and optionally importing a dashboard into Grafana

combined_script = """#!/bin/bash

# --- CONFIGURATION ---
GRAFANA_URL="http://localhost:3000"
GRAFANA_API_KEY="YOUR_API_KEY_HERE"  # <-- Replace this with your actual API key
DASHBOARD_JSON_PATH="/tmp/internet_intrusion_monitoring_dashboard.json"

# --- SYSTEM PREP ---
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# --- INSTALL FAIL2BAN ---
echo "Installing Fail2Ban..."
sudo apt install fail2ban -y

# Configure Fail2Ban to log to syslog
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOL
[DEFAULT]
loglevel = INFO
logtarget = SYSLOG
EOL

sudo systemctl restart fail2ban

# --- INSTALL LOKI + PROMTAIL ---
echo "Setting up Loki and Promtail..."
curl -s https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install loki promtail -y

# Create Promtail config
sudo tee /etc/promtail/config.yml > /dev/null <<EOL
server:
  http_listen_port: 9080
  grpc_listen_port: 9095

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://localhost:3100/loki/api/v1/push

scrape_configs:
  - job_name: 'fail2ban'
    static_configs:
      - targets:
          - localhost
        labels:
          job: fail2ban
          __path__: /var/log/fail2ban.log
EOL

sudo systemctl enable loki
sudo systemctl start loki
sudo systemctl enable promtail
sudo systemctl start promtail

# --- OPTIONAL: IMPORT GRAFANA DASHBOARD ---
echo "Creating dashboard JSON..."
cat > "$DASHBOARD_JSON_PATH" <<'EOF'
DASHBOARD_JSON_HERE
EOF

echo "Uploading dashboard to Grafana..."
curl -X POST "$GRAFANA_URL/api/dashboards/db" \
  -H "Authorization: Bearer $GRAFANA_API_KEY" \
  -H "Content-Type: application/json" \
  -d @"$DASHBOARD_JSON_PATH"

echo "Setup complete!"
"""

# Load the actual dashboard content created earlier
with open("/mnt/data/internet_intrusion_monitoring_dashboard.json", "r") as f:
    dashboard_json = json.load(f)

# Embed the dashboard JSON into the script
dashboard_json_str = json.dumps({"dashboard": dashboard_json["dashboard"], "overwrite": True})
script_with_dashboard = combined_script.replace("DASHBOARD_JSON_HERE", dashboard_json_str)

# Save the final script
combined_script_path = "/mnt/data/setupIntrusionMonitor.sh"
with open(combined_script_path, "w") as f:
    f.write(script_with_dashboard)

combined_script_path