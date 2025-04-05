#!/bin/bash
# ✅ Filename: setupNodeExporter.sh
# 📦 Purpose: Install and configure Node Exporter on Raspberry Pi OS (ARM64)
# 💻 Platform: Raspberry Pi OS Bookworm (aarch64)
# 🧠 Style: Follows PiosHarden.sh formatting with checklist comments

# ─────────────────────────────────────────────────────────────────────────────
# 📦 STEP 1: DOWNLOAD NODE EXPORTER (ARM64)
# ─────────────────────────────────────────────────────────────────────────────
echo "📦 Downloading Node Exporter for ARM64..."

TEMP_ARCHIVE="node_exporter-1.3.1.linux-arm64.tar.gz"
DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v1.3.1/${TEMP_ARCHIVE}"

if [ ! -f "$TEMP_ARCHIVE" ]; then
  curl -fLO "$DOWNLOAD_URL" || {
    echo "❌ Failed to download Node Exporter binary."
    exit 1
  }
else
  echo "⏭ Archive already exists, skipping download."
fi

# ─────────────────────────────────────────────────────────────────────────────
# 📂 STEP 2: EXTRACT AND INSTALL BINARY
# ─────────────────────────────────────────────────────────────────────────────
echo "📂 Extracting Node Exporter..."

tar -xzf "$TEMP_ARCHIVE"
sudo mv -f node_exporter-1.3.1.linux-arm64/node_exporter /usr/local/bin/

# Verify binary
if ! command -v node_exporter &> /dev/null; then
  echo "❌ node_exporter binary not found after install."
  exit 1
fi

# Clean up
rm -rf node_exporter-1.3.1.linux-arm64 "$TEMP_ARCHIVE"
echo "🧼 Cleanup complete."

# ─────────────────────────────────────────────────────────────────────────────
# ⚙️ STEP 3: CREATE SYSTEMD SERVICE
# ─────────────────────────────────────────────────────────────────────────────
echo "⚙️ Creating systemd service file..."

SERVICE_FILE="/etc/systemd/system/node_exporter.service"

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# ─────────────────────────────────────────────────────────────────────────────
# 🔁 STEP 4: RELOAD SYSTEMD AND (RE)START SERVICE
# ─────────────────────────────────────────────────────────────────────────────
echo "🔁 Enabling and starting Node Exporter..."

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl restart node_exporter

# ─────────────────────────────────────────────────────────────────────────────
# 🔥 STEP 5: ALLOW FIREWALL PORT 9100
# ─────────────────────────────────────────────────────────────────────────────
echo "🔥 Adding firewall rule for port 9100..."
sudo ufw allow 9100/tcp comment '🔸 Node Exporter Metrics'

# ─────────────────────────────────────────────────────────────────────────────
# 🔍 STEP 6: VERIFY PORT AND STATUS
# ─────────────────────────────────────────────────────────────────────────────
echo "🔍 Verifying exporter status and port binding..."

if curl -s --head http://localhost:9100/metrics | grep "200 OK" > /dev/null; then
  echo "✅ Node Exporter is running and accessible!"
  echo "🔗 Metrics available at: http://$(hostname -I | cut -d' ' -f1):9100/metrics"
else
  echo "⚠️ Node Exporter service running but not responding on port 9100."
  sudo systemctl status node_exporter
fi
