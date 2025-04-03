# Generate the setupVSCodeSSH.sh script that runs locally to enable passwordless SSH to Raspberry Pi

vscode_ssh_script = """#!/bin/bash

# =============================================================
# setupVSCodeSSH.sh — Interactive local script to enable
# passwordless SSH access from your machine to a Raspberry Pi.
# Works in Git Bash, WSL, or Linux/macOS terminals.
# Author: Blair
# =============================================================

echo "🔐 VS Code SSH Key Setup for Raspberry Pi"
echo "----------------------------------------"

# 1. Confirm target
read -p "Enter the Pi hostname or IP (e.g., 10.0.0.95): " pi_host
read -p "Enter the Pi username (default: blair): " pi_user
pi_user=${pi_user:-blair}

# 2. Generate SSH key if missing
key_path="$HOME/.ssh/id_ed25519"

if [ ! -f "$key_path" ]; then
  echo "📁 No SSH key found. Generating a new one..."
  ssh-keygen -t ed25519 -f "$key_path" -N "" -C "$USER@vscode"
else
  echo "✅ SSH key already exists at $key_path"
fi

# 3. Copy public key to the Pi
echo "📤 Sending public key to $pi_user@$pi_host"
if command -v ssh-copy-id >/dev/null 2>&1; then
  ssh-copy-id -i "$key_path.pub" "$pi_user@$pi_host"
else
  echo "⚠️ ssh-copy-id not available. Doing it manually..."
  pubkey=$(cat "$key_path.pub")
  ssh "$pi_user@$pi_host" "mkdir -p ~/.ssh && echo '$pubkey' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh"
fi

# 4. Test login
echo "🔍 Testing SSH login..."
ssh -o PasswordAuthentication=no "$pi_user@$pi_host" "echo '🎉 Success! You are now authenticated via SSH key.'"

echo "✅ SSH key-based login is set up. VS Code can now connect without password prompts."
echo "→ In VS Code, use 'Remote-SSH: Connect to Host' → $pi_user@$pi_host"
"""

script_path = "/mnt/data/setupVSCodeSSH.sh"
with open(script_path, "w") as f:
    f.write(vscode_ssh_script)

script_path