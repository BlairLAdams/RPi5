#!/bin/bash
# setupMetabase.sh
# ============================================================
# Fresh installation of Metabase and Java.
# Installs OpenJDK 11, downloads Metabase, and sets it up with systemd.
# ============================================================

set -e

# ------------------------------------------------------------
# Step 1: Clean up previous installations
# ------------------------------------------------------------

echo "⚠️ Removing any previous Metabase and Java installations..."

# Stop Metabase service if exists
sudo systemctl stop metabase.service || true
sudo systemctl disable metabase.service || true
sudo rm /etc/systemd/system/metabase.service || true

# Remove Metabase directory
rm -rf ~/scr/metabase || true

# Remove Java installations
sudo apt remove --purge openjdk-8-jdk openjdk-11-jdk -y || true

# Clean up environment variables in .bashrc
sed -i '/export JAVA_HOME/d' ~/.bashrc
sed -i '/export PATH.*jdk/d' ~/.bashrc
source ~/.bashrc

echo "✅ Clean up complete."

# ------------------------------------------------------------
# Step 2: Install OpenJDK (either 8 or 11)
# ------------------------------------------------------------

echo "📦 Installing OpenJDK 11 (required by Metabase)..."

# Update the package list and install OpenJDK 11
sudo apt update
sudo apt install -y openjdk-11-jdk

# Verify Java installation
java -version

echo "✅ Java 11 installed successfully!"

# ------------------------------------------------------------
# Step 3: Install and Set up Metabase
# ------------------------------------------------------------

echo "📦 Downloading and installing Metabase..."

# Download and extract Metabase
cd "$HOME/scr"
curl -L https://downloads.metabase.com/v0.43.0/metabase.tar.gz -o metabase.tar.gz
tar xvf metabase.tar.gz
rm metabase.tar.gz

echo "✅ Metabase downloaded and extracted to ~/scr/metabase."

# ------------------------------------------------------------
# Step 4: Create and Enable Metabase systemd service
# ------------------------------------------------------------

SERVICE_FILE="/etc/systemd/system/metabase.service"

echo "🛠 Creating systemd service for Metabase..."

# Create the systemd service file
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Metabase Service
After=network.target

[Service]
Type=simple
User=blair
WorkingDirectory=$HOME/scr/metabase
ExecStart=java -DMB_JETTY_PORT=3001 -jar $HOME/scr/metabase/metabase.jar
Restart=always
RestartSec=5
StandardOutput=append:$HOME/scr/logs/metabase.log
StandardError=append:$HOME/scr/logs/metabase.err

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the Metabase service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable metabase.service
sudo systemctl start metabase.service

echo "✅ Metabase service created and running in the background on port 3001."

# ------------------------------------------------------------
# Step 5: Final check and access instructions
# ------------------------------------------------------------

echo ""
echo "🌐 You can access Metabase at: http://localhost:3001"
echo "    Or remotely at: http://<pi-ip>:3001"
echo "    (Make sure port 3001 is open in your firewall)"
