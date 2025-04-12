#!/bin/bash
# initDagsterProject.sh
# ============================================================
# Scaffolds a minimal Dagster project with one asset using DuckDB.
# Author: Blair
#
# Description:
#   Creates a working Dagster project in ~/scr/dagsterdemo
#   with a simple asset and default configuration.
#
# Tasks:
#   ✅ Create dagsterdemo/ structure
#   ✅ Add one local asset
#   ✅ Enable Dagster dev UI
# ============================================================

set -e

PROJECT_ROOT="$HOME/scr/dagsterdemo"

# ------------------------------------------------------------
# Remove existing scaffold if it already exists
# ------------------------------------------------------------
if [ -d "$PROJECT_ROOT" ]; then
  echo "⚠️  Removing existing dagsterdemo project..."
  rm -rf "$PROJECT_ROOT"
fi

mkdir -p "$PROJECT_ROOT"
cd "$PROJECT_ROOT"

echo "📁 Initializing new Dagster project..."
dagster project scaffold --name dagsterdemo

echo "✅ Project scaffolded."

# ------------------------------------------------------------
# Create pyproject.toml file for Dagster recognition
# ------------------------------------------------------------
echo "📄 Creating pyproject.toml for Dagster configuration..."
cat > "$PROJECT_ROOT/pyproject.toml" <<EOF
[tool.dagster]
name = "dagsterdemo"
EOF

echo "✅ pyproject.toml created."

# ------------------------------------------------------------
# Add basic asset (replace default asset.py)
# ------------------------------------------------------------
ASSET_PATH="$PROJECT_ROOT/dagsterdemo/assets.py"

cat > "$ASSET_PATH" <<EOF
from dagster import asset
import duckdb

@asset
def hello_duckdb():
    conn = duckdb.connect(database="duckdemo.db", read_only=False)
    conn.execute("CREATE OR REPLACE TABLE hello AS SELECT 'Hello from Dagster + DuckDB!' AS message;")
    conn.close()
EOF

echo "✅ Asset written to: $ASSET_PATH"

# ------------------------------------------------------------
# Launch Dagster Web UI
# ------------------------------------------------------------
echo ""
echo "🚀 Launching Dagster UI at http://localhost:3000"
dagster dev
