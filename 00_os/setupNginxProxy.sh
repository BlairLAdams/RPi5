#!/bin/bash
# Filename: setupNginxProxy.sh
# Purpose: Set up NGINX reverse proxy for Grafana, Prometheus, and Node Exporter
# Scope: Local network access only; SSL and WAN exposure deferred to future phase

set -e  # Exit immediately if a command exits with a non-zero status

echo "Updating package lists and installing NGINX..."
sudo apt update
sudo apt install -y nginx

echo "Enabling and starting NGINX service..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Creating NGINX reverse proxy configuration for analytics stack..."
sudo tee /etc/nginx/sites-available/analytics-proxy > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location /grafana/ {
        proxy_pass http://localhost:3000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        rewrite ^/grafana/(.*)\$ /\\\$1 break;
    }

    location /prometheus/ {
        proxy_pass http://localhost:9090/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        rewrite ^/prometheus/(.*)\$ /\\\$1 break;
    }

    location /node/ {
        proxy_pass http://localhost:9100/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        rewrite ^/node/(.*)\$ /\\\$1 break;
    }
}
EOF

echo "Linking NGINX config into sites-enabled and disabling default site..."
sudo ln -s /etc/nginx/sites-available/analytics-proxy /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

echo "Reloading NGINX configuration..."
sudo systemctl reload nginx

echo "Adjusting Grafana server settings for sub-path serving..."
sudo sed -i 's|^;root_url =.*|root_url = %(protocol)s://%(domain)s/grafana/|' /etc/grafana/grafana.ini
sudo sed -i 's|^;serve_from_sub_path =.*|serve_from_sub_path = true|' /etc/grafana/grafana.ini

echo "Restarting Grafana service..."
sudo systemctl restart grafana-server

echo "NGINX reverse proxy setup complete!"
echo "You can now access:"
echo "- Grafana:     http://<your-pi-ip>/grafana/"
echo "- Prometheus:  http://<your-pi-ip>/prometheus/"
echo "- Node Exporter: http://<your-pi-ip>/node/metrics"
