#!/bin/bash
# ✅ Filename: bootstrapGitPullFirst.sh
# 📦 Purpose: Pull the repo into ~/scr before committing any local files
# 🧠 Run this on a clean Pi before local edits are staged

cd ~/scr || exit 1

# ─────────────────────────────────────────────────────────────────────────────
# 🔗 STEP 1: SET REMOTE ORIGIN IF MISSING
# ─────────────────────────────────────────────────────────────────────────────
if ! git remote get-url origin &>/dev/null; then
  echo "🔗 Setting remote origin..."
  git remote add origin git@github.com:blairladams/pi-scripts.git
fi

# ─────────────────────────────────────────────────────────────────────────────
# 📥 STEP 2: PULL REMOTE INTO EMPTY/UNBORN MAIN
# ─────────────────────────────────────────────────────────────────────────────
echo "📥 Pulling remote repo (main branch)..."
git fetch origin
git checkout -b main origin/main

# ─────────────────────────────────────────────────────────────────────────────
# 🧹 STEP 3: CLEAN STAGING AREA
# ─────────────────────────────────────────────────────────────────────────────
echo "🧹 Cleaning and showing updated repo structure..."
git status
ls -la

# ─────────────────────────────────────────────────────────────────────────────
# ✅ DONE
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Repo pulled cleanly. You can now add and commit local scripts."
