#!/bin/bash
# ✅ Filename: setupGrafana.sh
# 📦 Purpose: Install Grafana on Raspberry Pi OS (64-bit)
# 💻 Platform: Raspberry Pi OS Bookworm (aarch64)
# 🧠 Style: Follows PiosHarden-style with checklist comments

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 STEP 1: CLEAN UP PREVIOUS ATTEMPTS
# ─────────────────────────────────────────────────────────────────────────────
echo "🧹 Removing any previous Grafana attempts..."
sudo systemctl stop grafana-server 2>/dev/null
sudo apt-get remove grafana -y 2>/dev/null
sudo rm -rf /etc/grafana /var/lib/grafana /usr/share/grafana
sudo rm -f grafana_*.deb

# ─────────────────────────────────────────────────────────────────────────────
# 📥 STEP 2: DOWNLOAD ARM64 (aarch64) BUILD
# ─────────────────────────────────────────────────────────────────────────────
echo "📥 Downloading Grafana 10.3.1 ARM64 build..."
curl -fLO https://dl.grafana.com/oss/release/grafana_10.3.1_arm64.deb

# ─────────────────────────────────────────────────────────────────────────────
# 🛠 STEP 3: INSTALL THE DEB PACKAGE
# ─────────────────────────────────────────────────────────────────────────────
echo "🛠 Installing Grafana..."
sudo dpkg -i grafana_10.3.1_arm64.deb || sudo apt-get install -f -y

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 STEP 4: ENABLE + START SERVICE
# ─────────────────────────────────────────────────────────────────────────────
echo "🚀 Enabling and starting Grafana service..."
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 5: DONE
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Grafana should now be running!"
echo "🔗 Visit: http://$(hostname -I | cut -d' ' -f1):3000"
