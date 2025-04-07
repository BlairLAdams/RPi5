#!/bin/bash
#
# ✅ checkWebUIs.sh
# 📋 Diagnose Metabase and Dagster responsiveness issues on Raspberry Pi
#

echo "🔍 Checking system load..."
uptime
echo

echo "🧠 Top memory & CPU consumers:"
ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 10
echo

echo "📡 Port check (Metabase :3000)..."
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" http://localhost:3000
echo

echo "📡 Port check (Dagster :3300)..."
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" http://localhost:3300
echo

echo "📜 Latest Metabase logs:"
journalctl -u metabase.service --no-pager -n 20
echo

echo "📜 Latest Dagster logs:"
journalctl -u dagster.service --no-pager -n 20
echo

echo "🌡️ Throttle state (0x0 = normal):"
vcgencmd get_throttled
echo

echo "📈 Memory & disk usage:"
free -h
df -h /
echo

echo "✅ Done. If you see slow curl times or high CPU/mem, try restarting one service at a time:"
echo "   sudo systemctl restart metabase"
echo "   sudo systemctl restart dagster"
