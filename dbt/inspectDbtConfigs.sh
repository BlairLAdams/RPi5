#!/bin/bash
# ✅ Filename: inspectDbtConfigs.sh
# 📦 Purpose: Output all dbt config files to troubleshoot profile/db mismatch

echo "📁 Inspecting DBT Project Config:"
echo "──────────────────────────────────────────────"
cat ~/scr/dbt/dbt_project.yml || echo "❌ Missing: dbt_project.yml"

echo -e "\n📁 Inspecting DBT Profile Config:"
echo "──────────────────────────────────────────────"
cat ~/.dbt/profiles.yml || echo "❌ Missing: profiles.yml"

echo -e "\n📁 Listing models in ~/scr/dbt/models/:"
echo "──────────────────────────────────────────────"
find ~/scr/dbt/models/ -type f -name '*.sql'

echo -e "\n📁 Listing source file (if present):"
echo "──────────────────────────────────────────────"
cat ~/scr/dbt/models/_sources.yml 2>/dev/null || echo "⚠️ No _sources.yml found"

echo -e "\n📁 Confirming environment location:"
echo "──────────────────────────────────────────────"
echo "VENV: $VIRTUAL_ENV"
which dbt
dbt --version

echo -e "\n✅ Done. Review above and send me the output."
