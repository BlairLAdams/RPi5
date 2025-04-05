#!/bin/bash
# initDbtDemo.sh
# ============================================================
# Initializes and runs a simple dbt project using DuckDB.
# Author: Blair
#
# Description:
#   - Creates a new dbt project under ~/scr/duckdemo
#   - Selects the DuckDB adapter
#   - Adds a sample model
#   - Runs the model to validate dbt is working end-to-end
#
# Tasks:
#   ✅ Scaffold new project with dbt init
#   ✅ Auto-select dbt-duckdb
#   ✅ Create dummy model file
#   ✅ Run dbt to generate table
# ============================================================

set -e

PROJECT_ROOT="$HOME/scr"
PROJECT_NAME="duckdemo"
MODEL_DIR="$PROJECT_ROOT/$PROJECT_NAME/models/example"

echo "🛠 Creating dbt project: $PROJECT_NAME"
cd "$PROJECT_ROOT"

# Use 'expect' to automate adapter selection (DuckDB = option 1)
sudo apt install -y expect > /dev/null

expect <<EOF
spawn dbt init $PROJECT_NAME
expect "Enter a number: "
send "1\r"
expect eof
EOF

echo "✅ Project initialized at: $PROJECT_ROOT/$PROJECT_NAME"

# ------------------------------------------------------------
# Add a simple model
# ------------------------------------------------------------
echo "📄 Creating example model..."
mkdir -p "$MODEL_DIR"
echo "select 1 as hello_duckdb;" > "$MODEL_DIR/test_model.sql"

# ------------------------------------------------------------
# Run dbt
# ------------------------------------------------------------
echo "🚀 Running dbt..."
cd "$PROJECT_ROOT/$PROJECT_NAME"
dbt run

echo ""
echo "✅ dbt demo complete. Output stored in DuckDB file at $PROJECT_ROOT/$PROJECT_NAME/duckdemo.db"
