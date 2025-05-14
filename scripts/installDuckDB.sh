#!/bin/bash
#
# ✅ installDuckDB.sh — Install DuckDB CLI and Python bindings
# ------------------------------------------------------------
# Installs the DuckDB command-line interface and optionally
# installs the DuckDB Python package inside an activated venv.
#
# Tested on: Raspberry Pi OS Lite (Bookworm)
# ------------------------------------------------------------

set -e

echo "🔍 Checking for system dependencies..."

# 📦 Update package lists and install build tools
sudo apt-get update -y
sudo apt-get install -y wget unzip gcc make build-essential libreadline-dev

# 📁 Setup target folder for CLI
mkdir -p ~/duckdb/bin
cd ~/duckdb

# 🐥 Install DuckDB CLI (ARM64-compatible)
DUCKDB_CLI_URL="https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-aarch64.zip"
CLI_ZIP="duckdb_cli.zip"

if [ ! -f "bin/duckdb" ]; then
    echo "⬇️ Downloading DuckDB CLI from $DUCKDB_CLI_URL..."
    wget -O $CLI_ZIP "$DUCKDB_CLI_URL"
    unzip -o $CLI_ZIP -d bin
    chmod +x bin/duckdb
    rm $CLI_ZIP
    echo "✅ DuckDB CLI installed to ~/duckdb/bin/duckdb"
else
    echo "✅ DuckDB CLI already exists, skipping download."
fi

# 🧪 Add to PATH (if not already added)
if ! grep -q 'export PATH=$HOME/duckdb/bin:$PATH' ~/.bashrc; then
    echo 'export PATH=$HOME/duckdb/bin:$PATH' >> ~/.bashrc
    echo "📎 Added DuckDB CLI to PATH in ~/.bashrc"
fi

# 🐍 Install DuckDB Python package (if inside venv)
if [ -n "$VIRTUAL_ENV" ]; then
    echo "📦 Installing DuckDB Python bindings into active virtualenv..."
    pip install --upgrade pip
    pip install duckdb
    echo "✅ DuckDB Python bindings installed."
else
    echo "⚠️ Not in a Python virtualenv. Skipping Python package install."
    echo "💡 Tip: Run 'python3 -m venv ~/scr/venv && source ~/scr/venv/bin/activate'"
fi

echo "🎉 DuckDB installation complete."