#!/bin/bash
# ✅ Filename: pullFromGit.sh
# 📦 Purpose: Pull the remote Git repo into ~/scr on a fresh Pi
# 💻 Platform: Raspberry Pi OS Lite (headless)
# 🧠 Style: Follows PiosHarden-style headers and emoji checklist format

# ─────────────────────────────────────────────────────────────────────────────
# 📁 STEP 1: CHANGE TO ~/scr
# ─────────────────────────────────────────────────────────────────────────────
cd ~/scr || {
  echo "❌ Failed to change to ~/scr"
  exit 1
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔗 STEP 2: SET REMOTE ORIGIN IF NOT PRESENT
# ─────────────────────────────────────────────────────────────────────────────
if ! git remote get-url origin &>/dev/null; then
  echo "🔗 Setting Git remote origin to GitHub..."
  git remote add origin git@github.com:blairladams/RPi5.git
else
  echo "✅ Git remote already set."
fi

# ─────────────────────────────────────────────────────────────────────────────
# 📥 STEP 3: FETCH AND CHECKOUT REMOTE MAIN BRANCH
# ─────────────────────────────────────────────────────────────────────────────
echo "📥 Fetching remote repo and checking out main branch..."
git fetch origin
git checkout -B main origin/main

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 4: DONE
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Repo successfully pulled into ~/scr"
