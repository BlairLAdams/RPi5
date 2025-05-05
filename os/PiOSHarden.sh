#!/bin/bash
# PiosHarden.sh
# ============================================================
# Lightweight Pi OS Lite Hardening Script
# Author: Blair
#
# Description:
#   Removes Wi-Fi and Bluetooth services and drivers,
#   blacklists related kernel modules, and prompts for reboot.
#
# Tasks:
#   ✅ Remove Wi-Fi packages and services
#   ✅ Remove Bluetooth packages and services
#   ✅ Blacklist Wi-Fi and Bluetooth kernel modules
#   ✅ Prompt for reboot
# ============================================================

# ------------------------------------------------------------
# 1. Remove Wi-Fi Services & Packages
# ------------------------------------------------------------
echo "[1/4] Removing Wi-Fi packages and services..."
sudo apt purge -y wpasupplicant rfkill wireless-regdb crda || true

# ------------------------------------------------------------
# 2. Remove Bluetooth Services & Packages
# ------------------------------------------------------------
echo "[2/4] Removing Bluetooth packages and services..."
sudo apt purge -y pi-bluetooth bluez pulseaudio-module-bluetooth || true

# ------------------------------------------------------------
# 3. Blacklist Kernel Modules
# ------------------------------------------------------------
echo "[3/4] Blacklisting Wi-Fi and Bluetooth kernel modules..."
# Wi-Fi
echo "blacklist brcmfmac"  | sudo tee /etc/modprobe.d/disable-wifi.conf
echo "blacklist brcmutil"  | sudo tee -a /etc/modprobe.d/disable-wifi.conf

# Bluetooth
echo "blacklist btbcm"     | sudo tee /etc/modprobe.d/disable-bluetooth.conf
echo "blacklist hci_uart"  | sudo tee -a /etc/modprobe.d/disable-bluetooth.conf
echo "blacklist bluetooth" | sudo tee -a /etc/modprobe.d/disable-bluetooth.conf

# ------------------------------------------------------------
# 4. Clean up & Prompt for Reboot
# ------------------------------------------------------------
echo "[3b] Running apt autoremove to clean up dependencies..."
sudo apt autoremove -y

echo "[4/4] All done. A reboot is required to fully apply changes."
read -p "Would you like to reboot now? [y/N]: " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  sudo reboot
else
  echo "✅ You can reboot manually later with: sudo reboot"
fi
