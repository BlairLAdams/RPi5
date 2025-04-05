#!/bin/bash

# Description: Interactively logs into PostgreSQL and lists schemas, tables, and row counts in the water_analytics database.

echo "🔐 Enter your PostgreSQL login info to view database structure."
read -rp "PostgreSQL username: " DB_USER
read -rp "PostgreSQL host [default: localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}
read -rp "PostgreSQL port [default: 5432]: " DB_PORT
DB_PORT=${DB_PORT:-5432}
DB_NAME="water_analytics"

echo "🔍 Connecting to '$DB_NAME' and listing schemas, tables, and row counts..."

psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" <<EOSQL

-- Show all schemas
\dn

-- Show all tables grouped by schema
\dt bronze.*
\dt silver.*
\dt gold.*

-- Show row counts per table
SELECT
  table_schema || '.' || table_name AS table_full_name,
  row_estimate
FROM (
  SELECT
    schemaname AS table_schema,
    relname AS table_name,
    n_live_tup AS row_estimate
  FROM pg_stat_user_tables
  WHERE schemaname IN ('bronze', 'silver', 'gold')
) AS row_counts
ORDER BY table_schema, table_name;

-- Optional: list structure of tables
-- \d bronze.water_quality_raw
-- \d bronze.water_consumption_raw

EOSQL

echo "✅ Done."
