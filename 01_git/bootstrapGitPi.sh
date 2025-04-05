#!/bin/bash
# bootstrapGitPi.sh
# ============================================================
# Raspberry Pi Git Setup Bootstrap Script
# Author: Blair
#
# Description:
#   Sets up Git and SSH key-based GitHub access on a fresh Pi OS Lite system.
#   Includes automatic .gitignore override from a preferred location.
#
# Tasks:
#   ✅ Ensure Git is installed
#   ✅ Generate SSH key if missing
#   ✅ Display public key for GitHub Deploy Key setup
#   ✅ Set global Git identity
#   ✅ Clone or sync repo to ~/scr
#   ✅ Copy preferred .gitignore from 01_git (if present)
#   ✅ Apply .gitignore cleanup from top-level repo directory
#   ✅ Add ~/scr to shell PATH
# ============================================================

# --- USER CONFIGURATION -------------------------------------
GIT_NAME="Blair L Adams"
GIT_EMAIL="blair@hove2.ca"
GIT_REPO_SSH="git@github.com:blairladams/YOUR-REPO.git"
TARGET_DIR="$HOME/scr"
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
SHELL_RC="$HOME/.bashrc"
GITIGNORE_SOURCE="$TARGET_DIR/RPi5/01_git/.gitignore"

# ------------------------------------------------------------
# 1. Ensure Git is Installed
# ------------------------------------------------------------
echo "🧰 Checking for Git..."
if ! command -v git &> /dev/null; then
  echo "📦 Git not found — installing..."
  sudo apt update && sudo apt install git -y
else
  echo "✅ Git is already installed."
fi

# ------------------------------------------------------------
# 2. Create SSH Key if Missing
# ------------------------------------------------------------
echo "🔐 Checking SSH key..."
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "🔑 SSH key not found — generating new keypair..."
  mkdir -p ~/.ssh
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY_PATH" -N ""
  echo "📋 Public key generated. Add this to GitHub Deploy Keys:"
  echo "------------------------------------------------"
  cat "${SSH_KEY_PATH}.pub"
  echo "------------------------------------------------"
else
  echo "✅ SSH key already exists."
fi

# ------------------------------------------------------------
# 3. Configure Git Identity
# ------------------------------------------------------------
echo "🧾 Setting global Git identity..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# ------------------------------------------------------------
# 4. Clone or Refresh Git Repo
# ------------------------------------------------------------
echo "📁 Preparing $TARGET_DIR..."
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit 1

if [ -d .git ]; then
  echo "⚠️ Repo already initialized — skipping clone."
else
  echo "⬇️ Cloning repository from GitHub..."
  git clone "$GIT_REPO_SSH" .
fi

# ------------------------------------------------------------
# 5. Copy Preferred .gitignore (if available)
# ------------------------------------------------------------
if [ -f "$GITIGNORE_SOURCE" ]; then
  echo "📄 Copying preferred .gitignore from 01_git..."
  cp "$GITIGNORE_SOURCE" "$TARGET_DIR/.gitignore"
  echo "✅ .gitignore copied to repo root."
else
  echo "ℹ️ No override .gitignore found at $GITIGNORE_SOURCE — skipping copy."
fi

# ------------------------------------------------------------
# 6. Apply .gitignore Cleanup from Root
# ------------------------------------------------------------
echo "🧹 Searching for repo root to apply .gitignore cleanup..."
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [ -n "$REPO_ROOT" ] && [ -f "$REPO_ROOT/.gitignore" ]; then
  echo "✅ .gitignore found in $REPO_ROOT — cleaning tracked files..."
  cd "$REPO_ROOT" || exit 1
  git rm -rf --cached .
  git add .
  git commit -m "Reset tracked files with preferred .gitignore"
else
  echo "⚠️ .gitignore not found — skipping cleanup."
fi

# ------------------------------------------------------------
# 7. Add ~/scr to PATH (if not already)
# ------------------------------------------------------------
echo "💡 Ensuring ~/scr is in shell PATH..."
if ! grep -q 'export PATH="$HOME/scr:$PATH"' "$SHELL_RC"; then
  echo 'export PATH="$HOME/scr:$PATH"' >> "$SHELL_RC"
  source "$SHELL_RC"
  echo "✅ PATH updated in $SHELL_RC."
else
  echo "✅ ~/scr is already in PATH."
fi

# ------------------------------------------------------------
# Done
# ------------------------------------------------------------
echo "🎉 bootstrapPi.sh complete — Raspberry Pi is dev-ready."
