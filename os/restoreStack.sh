#!/bin/bash
# ♻️ restoreStack.sh — Restores configs and dashboards into the live environment

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/backup"
    exit 1
fi

BACKUP_DIR="$1"
echo "♻️ Restoring from $BACKUP_DIR ..."

# 🧠 Grafana
cp "$BACKUP_DIR/grafana.ini" ~/scr/grafana/ 2>/dev/null || echo "⚠️ grafana.ini missing"
cp -r "$BACKUP_DIR/grafana_provisioning" ~/scr/grafana/provisioning 2>/dev/null || echo "⚠️ provisioning missing"
cp -r "$BACKUP_DIR/grafana_dashboards" ~/scr/grafana/dashboards 2>/dev/null || echo "⚠️ dashboards missing"

# 🌀 Dagster
cp "$BACKUP_DIR/pyproject.toml" ~/scr/dagster/ 2>/dev/null || echo "⚠️ pyproject.toml missing"
cp "$BACKUP_DIR/workspace.yaml" ~/scr/dagster/ 2>/dev/null || echo "⚠️ workspace.yaml missing"
cp -r "$BACKUP_DIR/dagster_analytics" ~/scr/dagster/analytics 2>/dev/null || echo "⚠️ analytics missing"

# 📊 Prometheus
cp "$BACKUP_DIR/prometheus.yml" ~/scr/prometheus/ 2>/dev/null || echo "⚠️ prometheus.yml missing"
cp "$BACKUP_DIR/rules.yml" ~/scr/prometheus/ 2>/dev/null || echo "⚠️ rules.yml missing"

# 📈 DBT
cp "$BACKUP_DIR/dbt_project.yml" ~/scr/dbt/ 2>/dev/null || echo "⚠️ dbt_project.yml missing"
cp "$BACKUP_DIR/profiles.yml" ~/.dbt/ 2>/dev/null || echo "⚠️ profiles.yml missing"
cp -r "$BACKUP_DIR/dbt_models" ~/scr/dbt/models 2>/dev/null || echo "⚠️ dbt models missing"

# 📋 Metabase
cp "$BACKUP_DIR/metabase.db*.db" ~/scr/metabase/ 2>/dev/null || echo "⚠️ metabase.db.* missing"

echo "✅ Restore complete. Restart relevant services as needed."
