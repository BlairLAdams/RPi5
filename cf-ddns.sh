#!/bin/bash
# Filename: cf-ddns.sh
# Purpose: Update multiple Cloudflare A records with current public IP

# === CONFIGURATION ===
CF_API_TOKEN="your_cloudflare_api_token"  # Replace with your actual token
ZONE_NAME="hoveto.ca"
RECORD_NAMES=(
  "grafana.hoveto.ca"
  "prometheus.hoveto.ca"
  "nodex.hoveto.ca"
  "dagster.hoveto.ca"
  "dbt.hoveto.ca"
  "metadata.hoveto.ca"
)

# === DO NOT EDIT BELOW UNLESS CUSTOMIZING ===
IP_FILE="$HOME/.current_ip"
CF_API_URL="https://api.cloudflare.com/client/v4"
HEADERS=(
  -H "Authorization: Bearer B1BaE5bNWINMCeJiIMJgfghiHdy4T-t3cJzKZJ5F"
  -H "Content-Type: application/json"
)

CURRENT_IP=$(curl -s https://api.ipify.org)

if [[ -z "$CURRENT_IP" ]]; then
  echo "[Error] Unable to fetch current IP."
  exit 1
fi

if [[ -f "$IP_FILE" && "$(cat $IP_FILE)" == "$CURRENT_IP" ]]; then
  echo "[Info] IP unchanged ($CURRENT_IP). No update needed."
  exit 0
fi

ZONE_ID=$(curl -s -X GET "$CF_API_URL/zones?name=$ZONE_NAME" "${HEADERS[@]}" | jq -r '.result[0].id')

for RECORD_NAME in "${RECORD_NAMES[@]}"; do
  LOWER_RECORD_NAME=$(echo "$RECORD_NAME" | tr '[:upper:]' '[:lower:]')
  RECORD_ID=$(curl -s -X GET "$CF_API_URL/zones/$ZONE_ID/dns_records?type=A&name=$LOWER_RECORD_NAME" "${HEADERS[@]}" | jq -r '.result[0].id')

  if [[ "$RECORD_ID" == "null" || -z "$RECORD_ID" ]]; then
    echo "[Warning] Record not found: $RECORD_NAME. Skipping."
    echo "[Debug] Query used: $CF_API_URL/zones/$ZONE_ID/dns_records?type=A&name=$LOWER_RECORD_NAME"
    continue
  fi

  echo "[Updating] $RECORD_NAME → $CURRENT_IP"

  RESPONSE=$(curl -s -X PUT "$CF_API_URL/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    "${HEADERS[@]}" \
    --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":120,\"proxied\":false}")

  if echo "$RESPONSE" | grep -q "\"success\":true"; then
    echo "$CURRENT_IP" > "$IP_FILE"
    echo "[Success] Updated $RECORD_NAME"
  else
    echo "[Error] Failed to update $RECORD_NAME:"
    echo "$RESPONSE"
  fi
done