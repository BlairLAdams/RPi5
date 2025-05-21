#!/bin/bash
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
# ✅ File: setupMetabase.sh
# 📌 Purpose: Install and run Metabase on Raspberry Pi
# 🌐 Exposed at: https://metabase.hoveto.ca via NGINX
# 📁 Location: ~/scr/scripts/
# ☁️ Maintainer: blairladams @ github.com
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

set -e

# -------------------------------
# 📦 Download Metabase
# -------------------------------
echo "🌐 Downloading Metabase JAR..."
mkdir -p ~/scr/metabase
cd ~/scr/metabase
curl -L -o metabase.jar https://downloads.metabase.com/v0.49.10/metabase.jar

# -------------------------------
# 🛠️ Create Metabase systemd service
# -------------------------------
echo "🧾 Creating systemd service for Metabase..."
sudo tee /etc/systemd/system/metabase.service > /dev/null <<EOF
[Unit]
Description=Metabase analytics dashboard
After=network.target

[Service]
WorkingDirectory=/home/blair/scr/metabase
ExecStart=/usr/bin/java -jar /home/blair/scr/metabase/metabase.jar
Restart=always
User=blair
Environment=MB_DB_TYPE=postgres
Environment=MB_DB_DBNAME=metabase
Environment=MB_DB_PORT=5432
Environment=MB_DB_USER=blair
Environment=MB_DB_PASS=your_password_here
Environment=MB_DB_HOST=localhost
Environment=MB_JETTY_PORT=3001

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable metabase
sudo systemctl start metabase

# -------------------------------
# 🌐 Configure NGINX reverse proxy
# -------------------------------
echo "🌐 Configuring NGINX for metabase.hoveto.ca..."
sudo tee /etc/nginx/sites-available/metabase.hoveto.ca > /dev/null <<EOF
server {
    listen 80;
    server_name metabase.hoveto.ca;

    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/metabase.hoveto.ca /etc/nginx/sites-enabled/metabase.hoveto.ca
sudo nginx -t && sudo systemctl reload nginx

echo "✅ Metabase installed and served at https://metabase.hoveto.ca"
