#!/bin/bash
# ✅ Filename: updatePiOSLite.sh
# 📦 Purpose: Perform a full update and upgrade of Pi OS
# 💻 Platform: Raspberry Pi OS Lite (headless)
# 🧠 Style: Follows PiosHarden-style block headers and checklist format

# ─────────────────────────────────────────────────────────────────────────────
# 📥 STEP 1: SYSTEM UPDATE
# ─────────────────────────────────────────────────────────────────────────────
echo "📥 Updating package lists..."
sudo apt-get update -y

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 STEP 2: FULL SYSTEM UPGRADE
# ─────────────────────────────────────────────────────────────────────────────
echo "🔄 Upgrading packages..."
sudo apt-get full-upgrade -y

# ─────────────────────────────────────────────────────────────────────────────
# 🧹 STEP 3: REMOVE UNUSED PACKAGES
# ─────────────────────────────────────────────────────────────────────────────
echo "🧹 Removing unnecessary packages..."
sudo apt-get autoremove -y

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 4: SYSTEM CLEANUP
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Cleaning up..."
sudo apt-get clean

# ─────────────────────────────────────────────────────────────────────────────
# 📊 STEP 5: CHECK SYSTEM STATUS
# ─────────────────────────────────────────────────────────────────────────────
echo "📊 Checking disk usage..."
df -h
echo "📊 Checking memory usage..."
free -h

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 6: FINISHED
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Pi OS update complete!"
