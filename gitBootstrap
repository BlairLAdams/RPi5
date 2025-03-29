#!/bin/bash

# ==============================================================================
# SCRIPT: gitBootstrap
# PURPOSE: One-time setup for Raspberry Pi OS Lite using SSD for persistent files.
#
# This script:
#   1. Installs Git (if missing)
#   2. Mounts SSD at /mnt/ssd (assumes /dev/sda1 formatted as ext4)
#   3. Clones GitHub repo to /mnt/ssd/RPi5
#   4. Symlinks all executable scripts from /mnt/ssd/RPi5/scripts → ~/scr
#   5. Adds ~/scr to PATH via ~/.bashrc if needed
#   6. Creates config path at /mnt/ssd/grafana-config for Grafana assets (grafana.ini, dashboards)
#   7. Optionally runs gitRestore to rehydrate dotfiles
#   8. Optionally commits & pushes changes to GitHub
#
# USAGE:
#   scp gitBootstrap pi@raspberrypi.local:~/
#   ssh pi@raspberrypi.local
#   chmod +x ~/gitBootstrap
#   ./gitBootstrap
# ==============================================================================

set -e

REPO_SSH="git@github.com:blairladams/RPi5.git"
SSD_DEVICE="/dev/sda1"
MOUNT_POINT="/mnt/ssd"
CLONE_DIR="$MOUNT_POINT/RPi5"
SCRIPT_DIR="$CLONE_DIR/scripts"
SCR_PATH="$HOME/scr"
BACKUP_DIR="$MOUNT_POINT/backups"
GRAFANA_CONF_DIR="$MOUNT_POINT/grafana-config"

echo "🔧 Installing Git (if needed)..."
if ! command -v git &>/dev/null; then
  sudo apt update
  sudo apt install -y git
fi

echo "💾 Mounting SSD at $MOUNT_POINT..."
sudo mkdir -p "$MOUNT_POINT"
if ! mountpoint -q "$MOUNT_POINT"; then
  sudo mount "$SSD_DEVICE" "$MOUNT_POINT"
fi

echo "📁 Ensuring SSD folders exist..."
mkdir -p "$SCR_PATH"
mkdir -p "$BACKUP_DIR"
mkdir -p "$GRAFANA_CONF_DIR"

echo "📦 Cloning or updating GitHub repo to $CLONE_DIR..."
if [[ ! -d "$CLONE_DIR/.git" ]]; then
  git clone "$REPO_SSH" "$CLONE_DIR"
else
  git -C "$CLONE_DIR" pull
fi

echo "🔗 Linking scripts to ~/scr..."
find "$SCRIPT_DIR" -type f -executable -exec ln -sf {} "$SCR_PATH/" \;

if ! grep -q 'export PATH=\$HOME/scr:\$PATH' ~/.bashrc; then
  echo "🔧 Adding ~/scr to PATH in ~/.bashrc..."
  echo 'export PATH=$HOME/scr:$PATH' >> ~/.bashrc
fi
export PATH="$HOME/scr:$PATH"

echo "🧪 Validating key scripts..."
for script in gitBackup gitRestore; do
  if [[ ! -x "$SCR_PATH/$script" ]]; then
    echo "⚠️  Missing or not executable: $SCR_PATH/$script"
  else
    echo "✅ Found: $SCR_PATH/$script"
  fi
done

echo
read -rp "⚙️  Run gitRestore to rehydrate SSH and Git config? [y/N]: " confirm_restore
if [[ "$confirm_restore" =~ ^[Yy]$ ]]; then
  "$SCR_PATH/gitRestore"
else
  echo "⏭️  Skipping restore. Run manually with: $SCR_PATH/gitRestore"
fi

echo
read -rp "📤 Commit & push repo changes to GitHub now? [y/N]: " confirm_push
if [[ "$confirm_push" =~ ^[Yy]$ ]]; then
  cd "$CLONE_DIR"
  git status
  read -rp "📝 Enter commit message: " commit_msg
  git add .
  git commit -m "$commit_msg"
  git push
  echo "🚀 Git push complete."
else
  echo "⏭️  Skipping Git push."
fi

echo
echo "🎉 Bootstrap complete. Run 'source ~/.bashrc' or reopen your shell to finalize PATH."
