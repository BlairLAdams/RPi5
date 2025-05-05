#!/usr/bin/env bash
# removeDuckDNS.sh
# Description: Cleanly remove DuckDNS dynamic-DNS updater (cron jobs, systemd service, files)
# Usage: ./removeDuckDNS.sh [--dry-run]
# Features:
#  * Backs up user crontab and any system service files
#  * Supports dry-run to preview actions
#  * Idempotent: skips steps if already absent

set -euo pipefail

BASE_DIR="$HOME/scr"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "Dry-run mode: no changes will be made"
else
  # prompt for sudo up-front
  echo "Requesting sudo privilege…"
  sudo -v
fi

# 1) backup user crontab
CRON_BACKUP="$HOME/duckdns_crontab_backup_$(date +%Y%m%dT%H%M%S).cron"
echo "Backing up existing crontab to $CRON_BACKUP"
crontab -l > "$CRON_BACKUP" 2>/dev/null || echo "(no existing crontab)"

# 2) remove DuckDNS entries from user crontab
echo "Removing DuckDNS lines from user crontab"
FILTERED_CRON=$(grep -vE 'duckdns(\.sh)?' "$CRON_BACKUP" || true)
if [[ -z "$FILTERED_CRON" ]]; then
  echo "  (no DuckDNS entries found)"
else
  if $DRY_RUN; then
    echo "$FILTERED_CRON"
  else
    echo "$FILTERED_CRON" | crontab -
  fi
fi

# 3) remove /etc/cron.d/duckdns if it exists
if [[ -f /etc/cron.d/duckdns ]]; then
  echo "Found /etc/cron.d/duckdns – backing up and removing"
  if $DRY_RUN; then
    echo "  sudo cp /etc/cron.d/duckdns /etc/cron.d/duckdns.bak"
    echo "  sudo rm /etc/cron.d/duckdns"
  else
    sudo cp /etc/cron.d/duckdns /etc/cron.d/duckdns.bak
    sudo rm /etc/cron.d/duckdns
  fi
else
  echo "  no /etc/cron.d/duckdns file"
fi

# 4) disable and remove systemd service/timer
for unit in duckdns.service duckdns.timer; do
  if [[ -f /etc/systemd/system/$unit ]]; then
    echo "Disabling and removing systemd unit $unit"
    if $DRY_RUN; then
      echo "  sudo systemctl disable --now $unit"
      echo "  sudo rm /etc/systemd/system/$unit"
    else
      sudo systemctl disable --now "$unit"
      sudo rm "/etc/systemd/system/$unit"
    fi
  else
    echo "  $unit not present"
  fi
done

# reload systemd if not dry-run
if ! $DRY_RUN; then
  sudo systemctl daemon-reload
fi

# 5) remove DuckDNS script directory
DUCK_DIR="$HOME/duckdns"
if [[ -d $DUCK_DIR ]]; then
  echo "Removing DuckDNS directory $DUCK_DIR"
  if $DRY_RUN; then
    echo "  rm -rf $DUCK_DIR"
  else
    rm -rf "$DUCK_DIR"
  fi
else
  echo "  DuckDNS directory not found at $DUCK_DIR"
fi

# final summary
if $DRY_RUN; then
  echo
  echo "Dry-run complete. No changes written."
  echo "Re-run without --dry-run to actually remove DuckDNS."
else
  echo
  echo "DuckDNS has been cleanly removed."
fi
