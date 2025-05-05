#!/usr/bin/env bash
# cleanupPrefixes.sh
# Description:
#  - Remove numeric prefixes (for example “03_postgres” becomes “postgres”) from every directory under ~/scr
#  - Update any references in .sh, .service, .ini, .yml, .yaml, .py and .sql files
# Usage:
#   ./cleanupPrefixes.sh [--dry-run]
# Checklist:
#   - dry-run mode previews changes without writing
#   - creates a timestamped backup before touching anything
#   - skips directories already renamed

set -euo pipefail

BASE_DIR="$HOME/scr"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "Dry-run enabled; no files will be changed"
fi

# 1) backup
TS=$(date +%Y%m%dT%H%M%S)
BACKUP="$HOME/scr_backup_$TS.tar.gz"
echo "Creating backup at $BACKUP"
if ! $DRY_RUN; then
  tar czf "$BACKUP" -C "$HOME" scr
fi

# 2) rename directories
echo "Renaming directories under $BASE_DIR:"
shopt -s nullglob
for dir in "$BASE_DIR"/[0-9]*_*; do
  base=$(basename "$dir")
  new_name="${base#*_}"
  target="$BASE_DIR/$new_name"
  if [[ -d "$target" ]]; then
    echo "  skip $base (target $new_name exists)"
  else
    echo "  $base → $new_name"
    $DRY_RUN || mv "$dir" "$target"
  fi
done
shopt -u nullglob

# 3) patch references in code and config files
echo "Patching references in .sh .service .ini .yml .yaml .py .sql files:"
find "$BASE_DIR" \
  \( -name '*.sh' -o -name '*.service' -o -name '*.ini' \
   -o -name '*.yml' -o -name '*.yaml' \
   -o -name '*.py' -o -name '*.sql' \) \
  -type f | while read -r file; do
    echo "  $file"
    if $DRY_RUN; then
      sed -E "s#([/ ])[0-9]+_#\1#g" "$file" | diff -u "$file" - || true
    else
      sed -i.bak -E "s#([/ ])[0-9]+_#\1#g" "$file" \
        && rm -f "${file}.bak"
    fi
done

# 4) final message
if $DRY_RUN; then
  echo
  echo "Dry-run complete; no changes written. Rerun without --dry-run to apply."
else
  echo
  echo "Cleanup complete; prefixes removed and references updated."
fi
