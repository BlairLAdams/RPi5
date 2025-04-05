#!/bin/bash
# ✅ Filename: setupGit.sh
# 📦 Purpose: Install Git, configure identity, and prepare ~/scr for cloned repo
# 🧠 Assumes: SSH is working and you're running this on a freshly booted Pi OS Lite

# ─────────────────────────────────────────────────────────────────────────────
# 🛠 STEP 1: INSTALL GIT
# ─────────────────────────────────────────────────────────────────────────────
echo "📦 Installing Git..."
sudo apt update && sudo apt install -y git

# ─────────────────────────────────────────────────────────────────────────────
# 👤 STEP 2: CONFIGURE GIT IDENTITY
# ─────────────────────────────────────────────────────────────────────────────
echo "👤 Setting global Git config..."
git config --global user.name "blairladams"
git config --global user.email "blairladams@yourdomain.com"
git config --global init.defaultBranch main

# ─────────────────────────────────────────────────────────────────────────────
# 📁 STEP 3: CLONE REPO INTO ~/scr
# ─────────────────────────────────────────────────────────────────────────────
echo "📁 Cloning repo into ~/scr..."
mkdir -p ~/scr && cd ~/scr
git clone https://github.com/blairladams/pi-scripts.git .  # ← Update if needed

# ─────────────────────────────────────────────────────────────────────────────
# 🧭 STEP 4: ADD ~/scr TO PATH (FOR RUNNING SCRIPTS DIRECTLY)
# ─────────────────────────────────────────────────────────────────────────────
echo "🧭 Adding ~/scr to PATH..."
if ! grep -q 'export PATH="$HOME/scr:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/scr:$PATH"' >> ~/.bashrc
fi
source ~/.bashrc

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 5: DONE
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Git installed, repo ready in ~/scr, and PATH updated."

