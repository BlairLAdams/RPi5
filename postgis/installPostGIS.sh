#!/bin/bash
#
# 📄 installPostGIS.sh
# 🔧 Adds PostGIS support to PostgreSQL on Raspberry Pi 5
# ✅ Now creates target database if missing

set -e

## ─────────────────────────────────────────────
## ✅ Preflight Check: Ensure PostgreSQL is Installed
## ─────────────────────────────────────────────

echo "🔍 Checking for PostgreSQL installation..."
if ! command -v psql >/dev/null 2>&1; then
  echo "❌ PostgreSQL not found. Please install PostgreSQL first."
  exit 1
fi

## ─────────────────────────────────────────────
## 📦 Install PostGIS and Related Extensions
## ─────────────────────────────────────────────

echo "📦 Installing PostGIS and spatial extensions..."
sudo apt-get update
sudo apt-get install -y postgis postgresql-15-postgis-3 postgresql-15-postgis-3-scripts

## ─────────────────────────────────────────────
## 📋 Prompt for Target Database and User
## ─────────────────────────────────────────────

read -p "🔧 Enter the name of the PostgreSQL database to enable PostGIS [default: analytics]: " dbname
dbname="${dbname:-analytics}"

read -p "👤 Enter your PostgreSQL superuser name (e.g., postgres): " dbuser

## ─────────────────────────────────────────────
## 📦 Create DB if Needed
## ─────────────────────────────────────────────

echo "📁 Ensuring database '$dbname' exists..."
if ! sudo -u "$dbuser" psql -lqt | cut -d \| -f 1 | grep -qw "$dbname"; then
  echo "📄 Database not found. Creating '$dbname'..."
  sudo -u "$dbuser" createdb "$dbname"
else
  echo "✅ Database '$dbname' already exists."
fi

## ─────────────────────────────────────────────
## 🧪 Enable PostGIS in Target Database
## ─────────────────────────────────────────────

echo "📥 Enabling PostGIS extensions in $dbname..."
sudo -u "$dbuser" psql -d "$dbname" -c "CREATE EXTENSION IF NOT EXISTS postgis;"
sudo -u "$dbuser" psql -d "$dbname" -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"
sudo -u "$dbuser" psql -d "$dbname" -c "SELECT PostGIS_Full_Version();"

echo "✅ PostGIS setup complete in database '$dbname'."
