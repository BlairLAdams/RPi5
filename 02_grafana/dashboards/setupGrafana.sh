#!/bin/bash
# ✅ Filename: setupGrafana.sh
# 📦 Purpose: Install Grafana on Raspberry Pi OS Lite
# 💻 Platform: Raspberry Pi OS Lite (headless)
# 🧠 Style: Follows PiosHarden-style block headers and checklist format

# ─────────────────────────────────────────────────────────────────────────────
# 📦 STEP 1: ADD GRAFANA REPOSITORY
# ─────────────────────────────────────────────────────────────────────────────
echo "📦 Adding Grafana repository..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# ─────────────────────────────────────────────────────────────────────────────
# 🔑 STEP 2: INSTALL GRAFANA
# ─────────────────────────────────────────────────────────────────────────────
echo "🔑 Installing Grafana..."
sudo apt-get update
sudo apt-get install grafana -y

# ─────────────────────────────────────────────────────────────────────────────
# 🛠 STEP 3: ENABLE AND START GRAFANA SERVICE
# ─────────────────────────────────────────────────────────────────────────────
echo "🛠 Enabling and starting Grafana service..."
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 4: FINISHED
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Grafana installation complete!"
echo "🚀 Access Grafana at: http://<Pi-IP>:3000"
