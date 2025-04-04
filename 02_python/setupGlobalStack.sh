#!/bin/bash

# Description: Installs all required Python packages globally (without virtualenv) for ingestion, dbt, and Dagster workflows.

set -e

echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "🐍 Ensuring Python 3 and pip3 are available..."
sudo apt install -y python3 python3-pip

echo "📦 Installing Python stack globally using --break-system-packages..."

pip3 install --break-system-packages --upgrade pip

pip3 install --break-system-packages \
  polars \
  psycopg2-binary \
  dbt-core \
  dagster \
  dagster-postgres \
  dagster-webserver

echo ""
echo "✅ Global Python stack installed."
echo ""
echo "📍 Installed versions:"
python3 --version
pip3 --version
dbt --version
dagster --version

echo ""
echo "🧪 To run Dagster web UI:"
echo "   dagster dev"
echo ""
echo "🧪 To run dbt commands:"
echo "   dbt init <project_name>"
echo "   dbt run"
echo ""
echo "✅ All set. No virtual environments needed."