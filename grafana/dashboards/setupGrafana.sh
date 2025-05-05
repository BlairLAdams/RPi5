#!/bin/bash
# ✅ Filename: setupGrafana.sh
# 📦 Purpose: Install Grafana on Raspberry Pi OS (64-bit)
# 💻 Platform: Raspberry Pi OS Bookworm (aarch64)
# 🧠 Style: PiosHarden-format with full verification and clean reruns

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 STEP 1: CLEAN UP PREVIOUS INSTALLS
# ─────────────────────────────────────────────────────────────────────────────
echo "🧹 Cleaning up previous Grafana installations..."

sudo systemctl stop grafana-server 2>/dev/null
sudo systemctl disable grafana-server 2>/dev/null
sudo rm -rf /etc/grafana /var/lib/grafana /usr/share/grafana
sudo rm -f grafana_10.3.1_arm64.deb

# ─────────────────────────────────────────────────────────────────────────────
# 📥 STEP 2: DOWNLOAD GRAFANA DEB PACKAGE (ARM64)
# ─────────────────────────────────────────────────────────────────────────────
echo "📥 Downloading Grafana 10.3.1 ARM64 .deb package..."

curl -fLO https://dl.grafana.com/oss/release/grafana_10.3.1_arm64.deb || {
  echo "❌ Failed to download Grafana. Exiting."
  exit 1
}

# ─────────────────────────────────────────────────────────────────────────────
# 🛠️ STEP 3: INSTALL GRAFANA VIA dpkg
# ─────────────────────────────────────────────────────────────────────────────
echo "🛠 Installing Grafana .deb package..."

sudo dpkg -i grafana_10.3.1_arm64.deb || sudo apt-get install -f -y

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 STEP 4: ENABLE AND START SYSTEMD SERVICE
# ─────────────────────────────────────────────────────────────────────────────
echo "🚀 Enabling and starting grafana-server..."

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl restart grafana-server

# ─────────────────────────────────────────────────────────────────────────────
# 🔥 STEP 5: OPEN PORT 3000 IN FIREWALL
# ─────────────────────────────────────────────────────────────────────────────
echo "🔥 Opening port 3000 in UFW for Grafana UI..."
sudo ufw allow 3000/tcp comment '🔸 Grafana Web UI'

# ─────────────────────────────────────────────────────────────────────────────
# 🔍 STEP 6: VERIFY SERVICE AND PORT
# ─────────────────────────────────────────────────────────────────────────────
echo "🔍 Verifying Grafana service and network binding..."

if curl -s --head http://localhost:3000 | grep "200 OK" > /dev/null; then
  echo "✅ Grafana is running!"
  echo "🔗 Access Grafana at: http://$(hostname -I | cut -d' ' -f1):3000"
else
  echo "⚠️ Grafana service may be running, but it's not responding on port 3000."
  echo "   Check with: sudo journalctl -u grafana-server -n 50"
fi
