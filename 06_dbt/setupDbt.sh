#!/bin/bash
# setupDbt.sh
# ============================================================
# Installs dbt for use with DuckDB on Raspberry Pi OS Lite.
# Author: Blair
#
# Description:
#   Lightweight, no-server setup for local dbt development.
#   Uses --break-system-packages for PiOS compatibility.
#
# Tasks:
#   ✅ Upgrade pip
#   ✅ Install dbt-core and dbt-duckdb
#   ✅ Add ~/.local/bin to PATH if needed
#   ✅ Confirm version and test command
# ============================================================

set -e

# ------------------------------------------------------------
# 1. Upgrade pip
# ------------------------------------------------------------
echo "📦 Upgrading pip with --break-system-packages..."
pip3 install --break-system-packages --upgrade pip

# ------------------------------------------------------------
# 2. Install dbt-core and DuckDB adapter
# ------------------------------------------------------------
echo "📦 Installing dbt-core + dbt-duckdb..."
pip3 install --break-system-packages \
  dbt-core \
  dbt-duckdb

# ------------------------------------------------------------
# 3. Ensure ~/.local/bin is in PATH
# ------------------------------------------------------------
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo "💡 Adding ~/.local/bin to PATH..."
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  export PATH="$HOME/.local/bin:$PATH"
  echo "✅ PATH updated to include ~/.local/bin"
else
  echo "✅ ~/.local/bin already in PATH."
fi

# ------------------------------------------------------------
# 4. Confirm installation
# ------------------------------------------------------------
echo ""
echo "✅ dbt installed:"
dbt --version

echo ""
echo "🧪 Test dbt command:"
dbt --help | grep "init"

echo ""
echo "✅ setupDbt.sh complete — ready for local dbt projects using DuckDB."
