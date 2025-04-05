#!/bin/bash
# ✅ Filename: verifyGitSSHAccess.sh
# 📦 Purpose: Verify SSH deploy key access to GitHub from Pi and fix common issues
# 💻 Platform: Raspberry Pi OS Lite
# 🧠 Style: Follows PiosHarden-style block headers and comments

# ─────────────────────────────────────────────────────────────────────────────
# 🔐 STEP 1: CHECK FOR SSH DEPLOY KEY FILE
# ─────────────────────────────────────────────────────────────────────────────
if [ ! -f ~/.ssh/id_ed25519 ]; then
  echo "❌ Missing private key: ~/.ssh/id_ed25519"
  echo "👉 Please copy or generate the deploy key first."
  exit 1
else
  echo "✅ Deploy key found at ~/.ssh/id_ed25519"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 📁 STEP 2: ENSURE SSH CONFIG POINTS TO DEPLOY KEY FOR GITHUB
# ─────────────────────────────────────────────────────────────────────────────
mkdir -p ~/.ssh

echo "📄 Updating ~/.ssh/config for GitHub..."
cat > ~/.ssh/config <<EOF
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/config
echo "✅ SSH config updated."

# ─────────────────────────────────────────────────────────────────────────────
# 🔌 STEP 3: TEST SSH CONNECTION TO GITHUB
# ─────────────────────────────────────────────────────────────────────────────
echo "🔌 Testing SSH access to GitHub..."
ssh -T git@github.com

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 4: INSTRUCTIONS IF SUCCESSFUL OR FAILED
# ─────────────────────────────────────────────────────────────────────────────
echo
echo "🔎 If you see a greeting message (Hi blairladams!), the SSH connection works."
echo "🚧 If you see 'Permission denied', check GitHub deploy key settings:"
echo "   https://github.com/blairladams/RPi5/settings/keys"
