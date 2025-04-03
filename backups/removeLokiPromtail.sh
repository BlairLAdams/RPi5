#!/bin/bash
# removeLokiPromtail.sh - Cleanly removes Loki and Promtail from the system

echo "[INFO] Stopping services..."
sudo systemctl stop loki 2>/dev/null || true
sudo systemctl stop promtail 2>/dev/null || true

echo "[INFO] Disabling services..."
sudo systemctl disable loki 2>/dev/null || true
sudo systemctl disable promtail 2>/dev/null || true

echo "[INFO] Removing binaries..."
sudo rm -f /usr/local/bin/loki
sudo rm -f /usr/local/bin/promtail

echo "[INFO] Removing config files..."
sudo rm -f /etc/loki-config.yaml
sudo rm -f /etc/promtail-config.yaml

echo "[INFO] Removing systemd service files..."
sudo rm -f /etc/systemd/system/loki.service
sudo rm -f /etc/systemd/system/promtail.service

echo "[INFO] Removing Loki data directory..."
sudo rm -rf /opt/loki

echo "[INFO] Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "[SUCCESS] Loki and Promtail have been removed."
