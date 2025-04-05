#!/bin/bash
# ✅ Filename: setupUltraDashboard.sh
# 📦 Purpose: Upload UltraPiMonitor.json to Grafana via secure API call
# 🧠 Style: PiosHarden-style, secure prompt, full validation

# ─────────────────────────────────────────────────────────────────────────────
# 🔐 PROMPT FOR GRAFANA PASSWORD
# ─────────────────────────────────────────────────────────────────────────────
read -s -p "🔑 Enter Grafana admin password: " grafana_pw
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# 🧩 CHECK DASHBOARD FILE EXISTS
# ─────────────────────────────────────────────────────────────────────────────
DASH_PATH="./UltraPiMonitor.json"
if [ ! -f "$DASH_PATH" ]; then
  echo "❌ Dashboard file not found: $DASH_PATH"
  exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# 📡 UPLOAD DASHBOARD TO GRAFANA
# ─────────────────────────────────────────────────────────────────────────────
echo "📤 Uploading UltraPiMonitor.json to Grafana..."

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -u admin:$grafana_pw \
  -d @"$DASH_PATH" \
  http://localhost:3000/api/dashboards/db)

if [ "$RESPONSE" -eq 200 ] || [ "$RESPONSE" -eq 412 ]; then
  echo "✅ UltraPiMonitor dashboard loaded (HTTP $RESPONSE)"
else
  echo "❌ Dashboard upload failed (HTTP $RESPONSE)"
  exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# ✅ DONE
# ─────────────────────────────────────────────────────────────────────────────
echo "🔗 Open Grafana at: http://$(hostname -I | cut -d' ' -f1):3000"
