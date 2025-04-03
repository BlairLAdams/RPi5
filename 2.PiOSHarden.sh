#!/bin/bash

# ============================================================
# PiosHarden.sh — Lightweight Pi OS Lite Hardening Script
# Author: Blair
# Description:
#   Removes Wi-Fi and Bluetooth support for headless, wired-only setups.
#   Use for minimal, secure, and predictable Raspberry Pi installs.
#
# Currently enabled:
#   ✅ Remove Wi-Fi services and drivers
#   ✅ Remove Bluetooth services and drivers
#   ✅ Blacklist related kernel modules
#   ✅ Optional reboot prompt
#
# Optional future hardening (not active in this version):
#   ❌ Disable SSH password login
#   ❌ Disable root SSH access
#   ❌ Disable Avahi/mDNS (Bonjour)
#   ❌ Disable IPv6
#   ❌ Harden SSH config (AllowUsers blair, etc.)
#   ❌ Auto-security updates (unattended-upgrades)
#   ❌ SD card write reduction (/var/log to RAM or tmpfs)
#   ❌ Remove console autologin
# ============================================================

echo "[1/4] Removing Wi-Fi packages and services..."
sudo apt purge -y wpasupplicant rfkill wireless-regdb crda || true

echo "[2/4] Removing Bluetooth packages and services..."
sudo apt purge -y pi-bluetooth bluez pulseaudio-module-bluetooth || true

echo "[3/4] Blacklisting Wi-Fi and Bluetooth kernel modules..."
# Wi-Fi modules
echo "blacklist brcmfmac"  | sudo tee /etc/modprobe.d/disable-wifi.conf
echo "blacklist brcmutil"  | sudo tee -a /etc/modprobe.d/disable-wifi.conf

# Bluetooth modules
echo "blacklist btbcm"     | sudo tee /etc/modprobe.d/disable-bluetooth.conf
echo "blacklist hci_uart"  | sudo tee -a /etc/modprobe.d/disable-bluetooth.conf
echo "blacklist bluetooth" | sudo tee -a /etc/modprobe.d/disable-bluetooth.conf

echo "[3b] Running apt autoremove to clean up dependencies..."
sudo apt autoremove -y

echo "[4/4] All done. A reboot is required to fully apply changes."
read -p "Would you like to reboot now? [y/N]: " answer
if [[ \"$answer\" =~ ^[Yy]$ ]]; then
  sudo reboot
else
  echo "✅ You can reboot manually later with: sudo reboot"
fi