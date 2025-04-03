#!/bin/bash
# postgresAndSampleDataInstall.sh
# Full PostgreSQL reinstall with user password prompts and Pagila dataset loading

set -e

echo "[*] Removing old PostgreSQL..."
sudo systemctl stop postgresql || true
sudo apt-get purge -y postgresql* libpq-dev
sudo apt-get autoremove -y
sudo rm -rf /var/lib/postgresql /etc/postgresql /etc/postgresql-common /var/log/postgresql
sudo deluser postgres || true
sudo delgroup postgres || true

echo "[*] Reinstalling PostgreSQL..."
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib wget

# Prompt for passwords
echo "[*] Creating PostgreSQL users..."
read -sp "Enter a secure password for the 'postgres' superuser: " POSTGRES_PW
echo
read -sp "Enter a secure password for the 'metabase' PostgreSQL user: " METABASE_PW
echo

# Enable peer so we can set postgres password without needing one yet
PG_HBA="/etc/postgresql/15/main/pg_hba.conf"
sudo sed -i 's/^local\s\+all\s\+postgres\s\+\S\+/local   all             postgres                                peer/' "$PG_HBA"
sudo systemctl restart postgresql

# Set both passwords
echo "[*] Setting postgres and metabase passwords..."
sudo -u postgres psql <<EOF
ALTER USER postgres WITH PASSWORD '${POSTGRES_PW}';
CREATE USER metabase WITH PASSWORD '${METABASE_PW}';
CREATE DATABASE sampledb OWNER metabase;
EOF

# Switch everything to scram-sha-256
echo "[*] Enabling scram-sha-256 authentication for all connections..."
sudo sed -i 's/^local\s\+all\s\+postgres\s\+\S\+/local   all             postgres                                scram-sha-256/' "$PG_HBA"
sudo sed -i 's/^local\s\+all\s\+all\s\+\S\+/local   all             all                                     scram-sha-256/' "$PG_HBA"
sudo sed -i 's/^host\s\+all\s\+all\s\+127.0.0.1\/32\s\+\S\+/host    all             all             127.0.0.1\/32            scram-sha-256/' "$PG_HBA"
sudo sed -i 's/^host\s\+all\s\+all\s\+::1\/128\s\+\S\+/host    all             all             ::1\/128                 scram-sha-256/' "$PG_HBA"

# Enable remote access
echo "[*] Configuring postgresql.conf for remote access..."
PG_CONF="/etc/postgresql/15/main/postgresql.conf"
sudo sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g" "$PG_CONF"

echo "[*] Restarting PostgreSQL..."
sudo systemctl restart postgresql

# Load Pagila
echo "[*] Downloading Pagila dataset..."
cd /tmp
wget -q https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-schema.sql
wget -q https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-data.sql

echo "[*] Loading Pagila into sampledb..."
PGPASSWORD="$POSTGRES_PW" psql -U postgres -h localhost -d sampledb -f /tmp/pagila-schema.sql
PGPASSWORD="$POSTGRES_PW" psql -U postgres -h localhost -d sampledb -f /tmp/pagila-data.sql

echo "[*] Granting access to metabase user..."
PGPASSWORD="$POSTGRES_PW" psql -U postgres -h localhost -d sampledb <<EOF
GRANT CONNECT ON DATABASE sampledb TO metabase;
GRANT USAGE ON SCHEMA public TO metabase;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO metabase;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO metabase;
EOF

echo "[*] Opening port 5432 in UFW for remote access..."
sudo ufw allow 5432/tcp comment 'Allow PostgreSQL'

echo "[✓] PostgreSQL is fully installed with Pagila sample data."
echo "    User: postgres / Password: (what you entered)"
echo "    User: metabase / Password: (what you entered)"
echo "    Host: localhost"
echo "    Port: 5432"
echo "    DB: sampledb"
