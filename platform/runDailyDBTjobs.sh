#!/bin/bash
# Daily job runner for dbt (bare-metal install with PostgreSQL check, auto-start, and logging)

set -e

# Ensure the directory for the log file exists
LOG_DIR=~/dbt
mkdir -p $LOG_DIR

LOG_FILE="$LOG_DIR/daily_run.log"
echo "🔧 Starting daily run: $(date)" >> $LOG_FILE

echo "🌀 Activating Python virtual environment..."
source ~/venvs/analytics/bin/activate

echo "🩺 Checking if PostgreSQL is running..."
if ! pg_isready > /dev/null 2>&1; then
  echo "❌ PostgreSQL is not accepting connections. Attempting to start PostgreSQL..." >> $LOG_FILE
  sudo systemctl start postgresql || { echo "❌ Failed to start PostgreSQL. Please start the database manually."; exit 1; }
  echo "✅ PostgreSQL started successfully." >> $LOG_FILE
else
  echo "✅ PostgreSQL is already running." >> $LOG_FILE
fi

echo "🚀 Running dbt transformations..."
cd ~/dbt/pagila_project
dbt run --profiles-dir . >> $LOG_FILE 2>&1

# Capture the exit status of dbt run and log it
DBT_RUN_STATUS=$?
if [ $DBT_RUN_STATUS -ne 0 ]; then
  echo "❌ dbt run failed with exit status $DBT_RUN_STATUS" >> $LOG_FILE
  exit $DBT_RUN_STATUS
else
  echo "✅ dbt run completed successfully." >> $LOG_FILE
fi

echo "🧪 Running dbt tests..."
dbt test --profiles-dir . >> $LOG_FILE 2>&1

# Capture the exit status of dbt test and log it
DBT_TEST_STATUS=$?
if [ $DBT_TEST_STATUS -ne 0 ]; then
  echo "❌ dbt test failed with exit status $DBT_TEST_STATUS" >> $LOG_FILE
  exit $DBT_TEST_STATUS
else
  echo "✅ dbt tests passed." >> $LOG_FILE
fi

echo "📚 Regenerating dbt docs..."
dbt docs generate --profiles-dir . >> $LOG_FILE 2>&1

# Capture the exit status of dbt docs generation and log it
DBT_DOCS_STATUS=$?
if [ $DBT_DOCS_STATUS -ne 0 ]; then
  echo "❌ dbt docs generation failed with exit status $DBT_DOCS_STATUS" >> $LOG_FILE
  exit $DBT_DOCS_STATUS
else
  echo "✅ dbt docs generated successfully." >> $LOG_FILE
fi

echo "✅ Daily pipeline complete: $(date)" >> $LOG_FILE
