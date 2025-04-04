#!/bin/bash

# Description: Ensure Python and required libraries (polars, psycopg2) are installed for bronze layer ingestion

set -e

echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "🐍 Checking for Python 3 and pip..."
sudo apt install -y python3 python3-pip python3-venv

read -rp "Do you want to use a virtual environment? [y/N]: " USE_VENV

if [[ "$USE_VENV" =~ ^[Yy]$ ]]; then
  VENV_DIR="~/bronze_venv"
  echo "📦 Creating virtual environment at $VENV_DIR..."
  python3 -m venv "$VENV_DIR"
  # shellcheck disable=SC1090
  source "$VENV_DIR/bin/activate"
  echo "✅ Virtual environment activated."
fi

echo "📦 Installing Python packages: polars, psycopg2-binary..."
pip install --upgrade pip
pip install polars psycopg2-binary

echo "✅ Python setup complete. Ready to run bronze ingestion scripts."

if [[ "$USE_VENV" =~ ^[Yy]$ ]]; then
  echo "📎 Reminder: activate with 'source ~/bronze_venv/bin/activate' before running ingestion scripts."
fi

