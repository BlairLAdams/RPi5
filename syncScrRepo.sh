#!/bin/bash
# ✅ Filename: syncScrRepo.sh
# 📦 Purpose: Commit local changes in ~/scr and safely pull/push to remote repo
# 🧠 Notes: Assumes you're working in a clean Git repo cloned to ~/scr

cd ~/scr || exit 1

# ─────────────────────────────────────────────────────────────────────────────
# 🧼 STEP 1: STATUS CHECK
# ─────────────────────────────────────────────────────────────────────────────
echo "🔍 Checking git status..."
git status

# ─────────────────────────────────────────────────────────────────────────────
# 📂 STEP 2: ADD KNOWN FILES
# ─────────────────────────────────────────────────────────────────────────────
echo "➕ Adding working files..."
git add setupPiSSH.ps1 setupGit.sh README.md .gitignore

# ─────────────────────────────────────────────────────────────────────────────
# 💬 STEP 3: COMMIT
# ─────────────────────────────────────────────────────────────────────────────
echo "💬 Committing local changes..."
git commit -m "🧩 Initial working setup: SSH, Git, README, and .gitignore"

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 STEP 4: PULL WITH REBASE
# ─────────────────────────────────────────────────────────────────────────────
echo "🔄 Pulling from remote with rebase..."
git pull --rebase

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 STEP 5: PUSH TO REMOTE
# ─────────────────────────────────────────────────────────────────────────────
echo "🚀 Pushing to GitHub..."
git push

# ─────────────────────────────────────────────────────────────────────────────
# ✅ DONE
# ─────────────────────────────────────────────────────────────────────────────
echo "✅ Local and remote repo are now in sync."
