#!/bin/bash
# setupDagster.sh
# ============================================================
# Installs Dagster for local orchestration with DuckDB support.
# Author: Blair
#
# Description:
#   Installs core Dagster CLI and webserver, plus DuckDB support.
#   Adds ~/.local/bin to PATH if missing.
#
# Tasks:
#   ✅ Upgrade pip
#   ✅ Install Dagster CLI + webserver
#   ✅ Add ~/.local/bin to PATH
#   ✅ Confirm install
# ============================================================

set -e

echo "📦 Upgrading pip..."
pip3 install --break-system-packages --upgrade pip

echo "📦 Installing Dagster core + webserver + DuckDB adapter..."
pip3 install --break-system-packages \
  dagster \
  dagster-webserver \
  dagster-duckdb

# ------------------------------------------------------------
# Ensure ~/.local/bin is in PATH
# ------------------------------------------------------------
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo "💡 Adding ~/.local/bin to PATH..."
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  export PATH="$HOME/.local/bin:$PATH"
  echo "✅ PATH updated."
else
  echo "✅ ~/.local/bin already in PATH."
fi

# ------------------------------------------------------------
# Confirm Installation
# ------------------------------------------------------------
echo ""
echo "✅ Dagster installed:"
dagster --version

echo ""
echo "🧪 Test Dagster CLI:"
dagster --help | grep "dev"

echo ""
echo "✅ setupDagster.sh complete — run 'dagster dev' to start web UI."
