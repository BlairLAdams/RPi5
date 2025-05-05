#!/bin/bash
# checkPiHealth.sh
# ============================================================
# Raspberry Pi OS Health Check Script
# Author: Blair
#
# Description:
#   Verifies system update status, SSH hardening, disk usage,
#   memory usage, orphaned packages, and kernel error state.
#   Automatically runs apt autoremove and logs output.
#
# Tasks:
#   ✅ Confirm system update status
#   ✅ Check SSH hardening + UFW
#   ✅ Inspect memory, disk, and failed services
#   ✅ Report kernel errors
# ============================================================

# --- Setup Log File ---
TIMESTAMP=$(date +%F)
LOG_DIR="$HOME/scr/logs"
LOG_FILE="$LOG_DIR/pi_health_$TIMESTAMP.txt"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "🩺 Starting Raspberry Pi OS health check... [$TIMESTAMP]"
echo "------------------------------------------------------------"

# ------------------------------------------------------------
# 1. Package Update Status
# ------------------------------------------------------------
echo "📦 Checking if system packages are up to date..."
UPGRADE_COUNT=$(apt list --upgradable 2>/dev/null | grep -c "upgradable")
if [ "$UPGRADE_COUNT" -eq 0 ]; then
  echo "✅ System packages are up to date."
else
  echo "⚠️  $UPGRADE_COUNT packages can be upgraded."
fi

# ------------------------------------------------------------
# 2. Failed systemd services
# ------------------------------------------------------------
echo "🛠 Checking for failed system services..."
FAILED_SERVICES=$(systemctl --failed --no-legend)
if [ -z "$FAILED_SERVICES" ]; then
  echo "✅ No failed systemd services."
else
  echo "❌ Failed services detected:"
  echo "$FAILED_SERVICES"
fi

# ------------------------------------------------------------
# 3. Firewall status (UFW)
# ------------------------------------------------------------
echo "🛡 Checking UFW firewall status..."
if sudo ufw status | grep -q "Status: active"; then
  echo "✅ UFW is active."
else
  echo "⚠️  UFW is not active!"
fi

# ------------------------------------------------------------
# 4. SSH service + config
# ------------------------------------------------------------
echo "🔌 Verifying SSH is enabled and running..."
if systemctl is-active --quiet ssh; then
  echo "✅ SSH service is active."
else
  echo "❌ SSH service is not running!"
fi

echo "🔐 Checking SSH password authentication policy..."
if grep -qi '^PasswordAuthentication no' /etc/ssh/sshd_config; then
  echo "✅ Password login is disabled for SSH."
else
  echo "⚠️  Password login is still enabled for SSH."
fi

# ------------------------------------------------------------
# 5. Disk Usage
# ------------------------------------------------------------
echo "💾 Checking disk usage..."
df -h / | awk 'NR==1 || /\/$/ {print "Used:", $3, "Free:", $4, "Mount:", $6}'

# ------------------------------------------------------------
# 6. Memory Usage
# ------------------------------------------------------------
echo "🧠 Checking memory usage..."
free -h | awk 'NR==1 || NR==2 {print}'

# ------------------------------------------------------------
# 7. Autoremove Orphaned Packages
# ------------------------------------------------------------
echo "🧼 Checking for orphaned packages..."
AUTOREMOVE_OUTPUT=$(sudo apt autoremove --yes 2>&1)
if echo "$AUTOREMOVE_OUTPUT" | grep -qi "removed"; then
  echo "✅ Orphaned packages removed:"
  echo "$AUTOREMOVE_OUTPUT"
else
  echo "✅ No orphaned packages to remove."
fi

# ------------------------------------------------------------
# 8. Kernel Error Logs
# ------------------------------------------------------------
echo "🧯 Checking for critical kernel errors..."
KERNEL_ERRORS=$(dmesg --level=err | grep -v "Bluetooth" || true)
if [ -z "$KERNEL_ERRORS" ]; then
  echo "✅ No kernel errors found."
else
  echo "⚠️  Kernel errors detected:"
  echo "$KERNEL_ERRORS"
fi

echo "------------------------------------------------------------"
echo "✅ Health check complete. Output logged to $LOG_FILE"\