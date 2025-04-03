#!/bin/bash
# patchPgHba.sh
# Updates pg_hba.conf to allow password authentication for postgres and other users

set -e

PG_HBA="/etc/postgresql/15/main/pg_hba.conf"
BACKUP_PATH="/etc/postgresql/15/main/pg_hba.conf.bak.$(date +%Y%m%d-%H%M%S)"

echo "[*] Backing up current pg_hba.conf to $BACKUP_PATH"
sudo cp "$PG_HBA" "$BACKUP_PATH"

echo "[*] Updating authentication methods in pg_hba.conf..."

# Replace peer with scram-sha-256 for local postgres superuser
sudo sed -i 's/^local\s\+all\s\+postgres\s\+peer/local   all             postgres                                scram-sha-256/' "$PG_HBA"

# Ensure local all is scram-sha-256 (not peer)
sudo sed -i 's/^local\s\+all\s\+all\s\+peer/local   all             all                                     scram-sha-256/' "$PG_HBA"

# Ensure IPv4 and IPv6 entries use scram-sha-256
sudo sed -i 's/^host\s\+all\s\+all\s\+127.0.0.1\/32\s\+\S\+/host    all             all             127.0.0.1\/32            scram-sha-256/' "$PG_HBA"
sudo sed -i 's/^host\s\+all\s\+all\s\+::1\/128\s\+\S\+/host    all             all             ::1\/128                 scram-sha-256/' "$PG_HBA"

echo "[*] Restarting PostgreSQL..."
sudo systemctl restart postgresql

echo "[✓] PostgreSQL is now configured for password-based access (scram-sha-256)."
