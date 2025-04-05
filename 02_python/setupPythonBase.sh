#!/bin/bash
# setupPythonBase.sh
# ============================================================
# Installs core Python 3 packages for Raspberry Pi OS Lite.
# Author: Blair
#
# Description:
#   Designed for headless, secure setups. This installs only
#   lightweight, foundational tools (no dbt or Dagster yet).
#
#   Uses --break-system-packages explicitly, acknowledging PEP 668.
#
# Tasks:
#   ✅ Ensure Python 3 and pip3 are installed
#   ✅ Upgrade pip
#   ✅ Install lightweight tools: polars, requests, pyyaml, dotenv
#   ✅ Confirm installed versions
# ============================================================

set -e

# ------------------------------------------------------------
# 1. Ensure Python and pip are installed
# ------------------------------------------------------------
echo "🐍 [1/4] Installing python3 and pip3..."
sudo apt update
sudo apt install -y python3 python3-pip

# ------------------------------------------------------------
# 2. Upgrade pip (safe for system use)
# ------------------------------------------------------------
echo "📦 [2/4] Upgrading pip using --break-system-packages..."
pip3 install --break-system-packages --upgrade pip

# ------------------------------------------------------------
# 3. Install core Python packages
# ------------------------------------------------------------
echo "📦 [3/4] Installing minimal Python base packages..."
pip3 install --break-system-packages \
  polars \
  requests \
  pyyaml \
  python-dotenv

# ------------------------------------------------------------
# 4. Confirm installation
# ------------------------------------------------------------
echo ""
echo "✅ [4/4] Base Python stack installed."
echo ""
echo "📍 Versions:"
python3 --version
pip3 --version

echo ""
echo "🔍 Installed packages:"
pip3 list | grep -E 'polars|requests|yaml|dotenv'

echo ""
echo "✅ setupPythonBase.sh complete."
