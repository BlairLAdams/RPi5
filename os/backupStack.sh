#!/bin/bash
# 📦 backupStack.sh — Backs up configs and dashboards from Grafana, Dagster, Prometheus, dbt, and Metabase

set -e

# 📁 Setup
TIMESTAMP=$(date +"%Y%m%dT%H%M%S")
BACKUP_DIR="$HOME/scr/backups/$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo "🔄 Backing up to $BACKUP_DIR ..."

# 🧠 Grafana
cp -r ~/scr/grafana/grafana.ini "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  grafana.ini not found"
cp -r ~/scr/grafana/provisioning "$BACKUP_DIR/grafana_provisioning" 2>/dev/null || echo "⚠️  provisioning/ not found"
cp -r ~/scr/grafana/dashboards "$BACKUP_DIR/grafana_dashboards" 2>/dev/null || echo "⚠️  dashboards/ not found"

# 🌀 Dagster
cp -r ~/scr/dagster/pyproject.toml "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  pyproject.toml not found"
cp -r ~/scr/dagster/workspace.yaml "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  workspace.yaml not found"
cp -r ~/scr/dagster/analytics "$BACKUP_DIR/dagster_analytics" 2>/dev/null || echo "⚠️  analytics/ not found"

# 📊 Prometheus
cp -r ~/scr/prometheus/prometheus.yml "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  prometheus.yml not found"
cp -r ~/scr/prometheus/rules.yml "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  rules.yml not found"

# 📈 DBT
cp -r ~/scr/dbt/dbt_project.yml "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  dbt_project.yml not found"
cp -r ~/.dbt/profiles.yml "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  profiles.yml not found"
cp -r ~/scr/dbt/models "$BACKUP_DIR/dbt_models" 2>/dev/null || echo "⚠️  models/ not found"

# 📋 Metabase
cp -r ~/scr/metabase/metabase.db*.db "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  metabase.db.* not found"

echo "✅ Backup completed at $BACKUP_DIR"
