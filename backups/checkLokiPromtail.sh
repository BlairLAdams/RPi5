#!/bin/bash
# checkLokiPromtail.sh - Verifies Loki and Promtail services

echo "[INFO] Checking Loki status..."
if systemctl is-active --quiet loki; then
  echo "✅ Loki is running."
else
  echo "❌ Loki is NOT running."
fi

echo "[INFO] Checking Promtail status..."
if systemctl is-active --quiet promtail; then
  echo "✅ Promtail is running."
else
  echo "❌ Promtail is NOT running."
fi

echo "[INFO] Checking open ports..."
sudo netstat -tulnp | grep -E ':3100|:9080' || echo "⚠️ Expected ports not open (3100 for Loki, 9080 for Promtail)"
