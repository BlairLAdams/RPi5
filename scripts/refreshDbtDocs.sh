#!/bin/bash
# refreshDbtDocs.sh — Regenerates dbt docs and syncs to MkDocs

# Paths
DBT_DIR=~/scr/dbt
MKDOCS_DB=~/scr/mkdocs/docs/dbt_docs

# Activate venv if needed
source ~/scr/venv/bin/activate

# Rebuild dbt docs
cd "$DBT_DIR" || exit 1
dbt docs generate

# Clear old docs and copy new ones
rm -rf "$MKDOCS_DB"
mkdir -p "$MKDOCS_DB"
cp -r "$DBT_DIR/target/"* "$MKDOCS_DB"

# Optionally rebuild MkDocs
cd ~/scr/mkdocs || exit 1
mkdocs build --clean
sudo systemctl restart mkdocs

echo "✅ dbt docs refreshed and published to MkDocs at $(date)"
