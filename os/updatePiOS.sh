#!/bin/bash
# updatePiOS.sh - Safe system update for Raspberry Pi OS Lite

set -e

echo "🔍 Updating package index..."
sudo apt update

echo "⬆️  Upgrading installed packages..."
sudo apt full-upgrade -y

echo "🧼 Cleaning up unused packages..."
sudo apt autoremove -y
sudo apt clean

echo "📦 Optional: Update firmware (skip if not needed)..."
# Uncomment to enable:
# sudo rpi-update

echo "✅ Update complete. Reboot if kernel or firmware changed."
