#!/bin/bash
# ✅ Filename: killZombieTerminals.sh
# 🧟 Purpose: Kill zombie terminal shells (bash/sh/zsh) safely, leaving current session alive
# 🧠 Notes: Also optionally clears VS Code remote cache to stop terminal resurrection

echo "🔍 Detecting current TTY..."
CURRENT_TTY=$(tty | awk -F'/' '{print $NF}')
echo "✅ You are on: $CURRENT_TTY"

echo "📋 Listing shell sessions (excluding yours)..."
ps -eo pid,tty,comm | grep -E 'bash|sh|zsh' | grep -v "$CURRENT_TTY" | grep -v 'grep' | while read -r PID TTY CMD; do
  echo "🗡️ Killing zombie shell PID $PID ($CMD on $TTY)..."
  kill -9 "$PID" 2>/dev/null
done

echo "🧹 Optional cleanup: VS Code server cache"
read -p "❓ Remove ~/.vscode-server to fully reset remote sessions? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  rm -rf ~/.vscode-server
  echo "✅ VS Code server cache removed."
else
  echo "⏭️ Skipping cache removal."
fi

echo "🏁 Done. Zombie terminals cleared (except this one)."
