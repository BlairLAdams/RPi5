#!/bin/bash
# metabaseInstall.sh - Installs Metabase on Raspberry Pi 5 on port 3030

set -e

echo "[*] Installing Java (OpenJDK 17)..."
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk curl

echo "[*] Creating /opt/metabase directory..."
sudo mkdir -p /opt/metabase
sudo chown "$USER":"$USER" /opt/metabase

echo "[*] Downloading Metabase latest release..."
curl -L -o /opt/metabase/metabase.jar https://downloads.metabase.com/v0.49.10/metabase.jar

echo "[*] Creating metabase systemd service on port 3030..."
sudo tee /etc/systemd/system/metabase.service > /dev/null <<EOF
[Unit]
Description=Metabase analytics platform
After=network.target

[Service]
ExecStart=/usr/bin/java -DMB_JETTY_PORT=3030 -jar /opt/metabase/metabase.jar
WorkingDirectory=/opt/metabase
User=$USER
Restart=always
Environment=MB_DB_FILE=/opt/metabase/metabase.db

[Install]
WantedBy=multi-user.target
EOF

echo "[*] Reloading systemd and starting Metabase..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable metabase
sudo systemctl start metabase

echo "[*] Metabase is now running on http://<your-pi-ip>:3030"
