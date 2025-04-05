#!/bin/bash
# BasicPiOSTools.sh - Base setup for Raspberry Pi OS Lite (headless)
# Installs essential tools, enables SSH & firewall, configures timezone, and prepares Python environment

set -e

echo "🛠 Starting base system setup..."

# ---------------------------------------------------------
# 1. System Update
# ---------------------------------------------------------
echo "📦 Updating package lists and upgrading system..."
sudo apt update && sudo apt upgrade -y

# ---------------------------------------------------------
# 2. Install Core Tools
# ---------------------------------------------------------
echo "📦 Installing essential tools..."
sudo apt install -y \
  python3 \
  python3-pip \
  git \
  curl \
  wget \
  htop \
  ufw \
  unzip \
  net-tools \
  bash-completion \
  unattended-upgrades \
  vim \
  ca-certificates \
  gnupg \
  lsb-release

# ---------------------------------------------------------
# 3. Configure Timezone
# ---------------------------------------------------------
echo "🌐 Setting timezone to UTC..."
sudo timedatectl set-timezone UTC

# ---------------------------------------------------------
# 4. Configure Firewall
# ---------------------------------------------------------
echo "🛡 Enabling UFW firewall and allowing SSH..."
sudo ufw allow OpenSSH
sudo ufw --force enable

# ---------------------------------------------------------
# 5. Enable SSH
# ---------------------------------------------------------
echo "🔌 Ensuring SSH is enabled and running..."
sudo systemctl enable ssh
sudo systemctl start ssh

# ---------------------------------------------------------
# 6. Enable Unattended Upgrades
# ---------------------------------------------------------
echo "🔒 Enabling unattended security upgrades..."
sudo dpkg-reconfigure --priority=low unattended-upgrades

# ---------------------------------------------------------
# 7. Cleanup
# ---------------------------------------------------------
echo "🧹 Cleaning up package cache..."
sudo apt autoremove -y
sudo apt autoclean -y

# ---------------------------------------------------------
# 8. Confirm Python Setup
# ---------------------------------------------------------
echo "🐍 Verifying Python environment..."
python3 --version
pip3 --version

echo "✅ Base system setup complete."
