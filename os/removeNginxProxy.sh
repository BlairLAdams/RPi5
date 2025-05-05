#!/bin/bash
# Filename: removeNginxProxy.sh
# Purpose: Remove NGINX reverse proxy configuration for analytics stack
# Scope: Safe rollback to default NGINX state

set -e  # Exit immediately if a command exits with a non-zero status

echo "Stopping NGINX service..."
sudo systemctl stop nginx

echo "Removing analytics proxy configuration..."
sudo rm -f /etc/nginx/sites-enabled/analytics-proxy
sudo rm -f /etc/nginx/sites-available/analytics-proxy

echo "Restoring default NGINX site configuration..."
# Optional: If you want the default "Welcome to NGINX" page back
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

echo "Reloading NGINX configuration..."
sudo systemctl reload nginx
sudo systemctl restart nginx

echo "Resetting Grafana server settings if needed..."
# Caution: This resets root_url and serve_from_sub_path back to defaults
sudo sed -i 's|^root_url =.*|;root_url = %(protocol)s://%(domain)s/|' /etc/grafana/grafana.ini
sudo sed -i 's|^serve_from_sub_path =.*|;serve_from_sub_path = false|' /etc/grafana/grafana.ini

echo "Restarting Grafana service..."
sudo systemctl restart grafana-server

echo "Rollback complete!"
echo "NGINX is now serving default site."
echo "Grafana is now back on default root path (no sub-path)."
