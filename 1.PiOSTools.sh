#!/bin/bash
# BasicPiOSTools - Base setup for Raspberry Pi OS Lite (headless)
# Installs basic utilities, configures timezone, SSH, and updates system

set -e

echo "🛠 Starting base system setup..."

# Update & upgrade
echo "📦 Updating package lists..."
sudo apt update && sudo apt upgrade -y

# Install essential tools
echo "📦 Installing base packages..."
sudo apt install -y \
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

# Set timezone (optional: update to your local zone if needed)
echo "🌐 Setting timezone to UTC..."
sudo timedatectl set-timezone UTC

# Enable UFW and allow SSH
echo "🛡 Enabling UFW firewall..."
sudo ufw allow OpenSSH
sudo ufw --force enable

# Enable unattended security updates
echo "🔒 Enabling unattended upgrades..."
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Confirm SSH is enabled
echo "🔌 Ensuring SSH is enabled..."
sudo systemctl enable ssh
sudo systemctl start ssh

# Final system upgrade and cleanup
echo "📦 Final upgrade and cleanup..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "✅ Base system setup complete."
