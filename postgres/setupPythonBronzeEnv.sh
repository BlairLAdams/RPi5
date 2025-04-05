#!/bin/bash

# Description: Globally install required Python packages for the bronze ingestion layer

echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "🐍 Ensuring python3 and pip3 are installed..."
sudo apt install -y python3 python3-pip

echo "📦 Installing global Python packages with --break-system-packages..."

pip3 install --break-system-packages --upgrade pip
pip3 install --break-system-packages polars psycopg2-binary

echo "✅ Global Python environment ready. Use 'python3 script.py' to run bronze ingests."
