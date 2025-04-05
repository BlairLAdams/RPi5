#!/bin/bash

# Description: Creates a PostgreSQL database `water_analytics`,
# along with `bronze`, `silver`, and `gold` schemas and initial bronze tables.

echo "🔐 You will now be prompted for your PostgreSQL credentials."
read -rp "PostgreSQL username: " DB_USER
read -rp "PostgreSQL host [default: localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}
read -rp "PostgreSQL port [default: 5432]: " DB_PORT
DB_PORT=${DB_PORT:-5432}

DB_NAME="water_analytics"

echo "🔍 Checking if database '$DB_NAME' exists..."

DB_EXIST=$(psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")
if [[ "$DB_EXIST" != "1" ]]; then
  echo "📦 Creating database '$DB_NAME'..."
  createdb -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" "$DB_NAME"
else
  echo "✅ Database '$DB_NAME' already exists."
fi

echo "📂 Creating schemas and tables in '$DB_NAME'..."

psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" <<'EOSQL'
-- Create schemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- Create tables in the bronze schema
CREATE TABLE IF NOT EXISTS bronze.water_quality_raw (
    sample_id SERIAL PRIMARY KEY,
    location VARCHAR,
    date DATE,
    parameter VARCHAR,
    value NUMERIC,
    unit VARCHAR,
    detection_limit NUMERIC,
    quality_flag VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze.water_consumption_raw (
    record_id SERIAL PRIMARY KEY,
    user_id INT,
    date_time TIMESTAMP,
    consumption_liters NUMERIC
);
EOSQL

echo "✅ Schemas and tables created successfully in '$DB_NAME'."