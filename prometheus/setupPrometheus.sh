#!/bin/bash
# ✅ Filename: setupPrometheus.sh
# 📦 Purpose: Install Prometheus on Raspberry Pi with proper scrape config, alertmanager integration, and remote_write setup
# 🧠 Style: PiosHarden-style—full comments, graceful handling, and idempotent setup

set -e

# ─────────────────────────────────────────────────────────────────────────────
# 🧹 STEP 1: CLEAN UP ANY PREVIOUS INSTALLATION
# ─────────────────────────────────────────────────────────────────────────────
echo "🧹 Cleaning up any previous Prometheus install..."
sudo systemctl stop prometheus 2>/dev/null || true
sudo systemctl disable prometheus 2>/dev/null || true
sudo rm -rf /etc/prometheus /var/lib/prometheus /usr/local/bin/prometheus /usr/local/bin/promtool /etc/systemd/system/prometheus.service /tmp/prometheus*

# ─────────────────────────────────────────────────────────────────────────────
# 📥 STEP 2: DOWNLOAD AND EXTRACT PROMETHEUS
# ─────────────────────────────────────────────────────────────────────────────
echo "📥 Downloading Prometheus for ARM64..."
cd /tmp
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-2.51.2.linux-arm64.tar.gz
tar xvf prometheus-2.51.2.linux-arm64.tar.gz
cd prometheus-2.51.2.linux-arm64

# ─────────────────────────────────────────────────────────────────────────────
# 📂 STEP 3: INSTALL PROMETHEUS BINARIES AND DIRECTORIES
# ─────────────────────────────────────────────────────────────────────────────
echo "📂 Installing Prometheus binaries and config..."
sudo useradd --no-create-home --shell /bin/false prometheus || true

sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo cp prometheus promtool /usr/local/bin/
sudo cp -r consoles console_libraries /etc/prometheus/

sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

# ─────────────────────────────────────────────────────────────────────────────
# 📝 STEP 4: WRITE CONFIG WITH NODE_EXPORTER, ALERTMANAGER, AND REMOTE_WRITE
# ─────────────────────────────────────────────────────────────────────────────
echo "📝 Writing prometheus.yml with node_exporter, alertmanager, and remote_write..."
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 15s
  evaluation_interval: 15s

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets: ['localhost:9093']

# Scrape configurations
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]

# remote_write config (example, remove if not using external storage)
remote_write:
  - url: "http://example-remote-storage.com/write"  # Change to actual URL
EOF

sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

# ─────────────────────────────────────────────────────────────────────────────
# ⚙️ STEP 5: CREATE SYSTEMD SERVICE UNIT
# ─────────────────────────────────────────────────────────────────────────────
echo "⚙️ Creating systemd unit for Prometheus..."
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# ─────────────────────────────────────────────────────────────────────────────
# 🔁 STEP 6: ENABLE AND START PROMETHEUS SERVICE
# ─────────────────────────────────────────────────────────────────────────────
echo "🔁 Enabling and starting Prometheus..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# ─────────────────────────────────────────────────────────────────────────────
# 🔥 STEP 7: OPEN FIREWALL PORT 9090
# ─────────────────────────────────────────────────────────────────────────────
echo "🔥 Opening port 9090 for Prometheus UI..."
sudo iptables -C INPUT -p tcp --dport 9090 -j ACCEPT 2>/dev/null || sudo iptables -I INPUT -p tcp --dport 9090 -j ACCEPT
sudo ip6tables -C INPUT -p tcp --dport 9090 -j ACCEPT 2>/dev/null || sudo ip6tables -I INPUT -p tcp --dport 9090 -j ACCEPT

# ─────────────────────────────────────────────────────────────────────────────
# 🔍 STEP 8: VERIFY SERVICE + TARGETS
# ─────────────────────────────────────────────────────────────────────────────
echo "🔍 Verifying Prometheus is active and serving UI..."

sleep 5
curl -s http://localhost:9090/api/v1/targets | grep -q node_exporter && \
  echo "✅ Prometheus is scraping node_exporter successfully." || \
  echo "⚠️ Prometheus is up but node_exporter scrape failed. Check config."

# ─────────────────────────────────────────────────────────────────────────────
# ✅ DONE
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Prometheus setup complete."
echo "🔗 Open in browser: http://$(hostname -I | cut -d' ' -f1):9090"
