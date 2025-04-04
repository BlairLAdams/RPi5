#!/bin/bash
# Bare-metal analytics stack init for Raspberry Pi OS Lite
set -e

echo "[INFO] Creating local project directories..."

# Create directories for DBT, Dagster, and necessary files
mkdir -p ~/dbt/pagila_project/models ~/dagster_workspace

# DBT setup: Create the dbt_project.yml file if it doesn't exist
if [ ! -f ~/dbt/pagila_project/dbt_project.yml ]; then
  echo "[INFO] Creating default dbt_project.yml..."
  cat > ~/dbt/pagila_project/dbt_project.yml <<'EOF'
name: 'pagila_project'
version: '1.0'
profile: 'openstack_project'
config-version: 2
model-paths: ["models"]
models:
  pagila_project:
    +materialized: view
EOF
else
  echo "[INFO] dbt_project.yml already exists."
fi

# Create sample DBT models if they don't exist
if [ ! -f ~/dbt/pagila_project/models/rentals_summary.sql ]; then
  echo "[INFO] Creating sample rentals_summary.sql model..."
  cat > ~/dbt/pagila_project/models/rentals_summary.sql <<'EOF'
SELECT customer_id, COUNT(*) AS total_rentals
FROM rental
GROUP BY customer_id
ORDER BY total_rentals DESC
LIMIT 10;
EOF
else
  echo "[INFO] rentals_summary.sql model already exists."
fi

if [ ! -f ~/dbt/pagila_project/models/schema.yml ]; then
  echo "[INFO] Creating schema.yml..."
  cat > ~/dbt/pagila_project/models/schema.yml <<'EOF'
version: 2
models:
  - name: rentals_summary
    description: "Top customers by total rentals"
    columns:
      - name: customer_id
        description: "The unique ID of the customer"
        tests:
          - not_null
      - name: total_rentals
        description: "Number of rentals completed by the customer"
EOF
else
  echo "[INFO] schema.yml already exists."
fi

# Check if the PostgreSQL profile exists, if not create it
PROFILE_PATH=~/.dbt/profiles.yml
if ! grep -q "openstack_project" $PROFILE_PATH; then
  echo "[INFO] Creating PostgreSQL profile for DBT..."
  cat >> $PROFILE_PATH <<EOF
openstack_project:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      password: 
      dbname: sampledb
      schema: public
      threads: 1
      port: 5432
EOF
else
  echo "[INFO] PostgreSQL profile already exists."
fi

# Python virtual environment setup if not exists
if [ ! -d ~/venvs/analytics ]; then
  echo "[INFO] Setting up Python virtual environment for analytics tools..."
  sudo apt update
  sudo apt install -y python3-pip python3-venv
  python3 -m venv ~/venvs/analytics
  source ~/venvs/analytics/bin/activate

  echo "[INFO] Installing dbt-postgres, dagster, and dagit..."
  pip install dbt-postgres dagster dagit
else
  echo "[INFO] Virtual environment already exists. Activating..."
  source ~/venvs/analytics/bin/activate
fi

# Setup firewall
echo "[INFO] Configuring UFW firewall rules..."
sudo ufw allow 22/tcp     comment 'Allow SSH'
sudo ufw allow 3000/tcp   comment 'Allow Grafana'
sudo ufw allow 9090/tcp   comment 'Allow Prometheus'
sudo ufw allow 3030/tcp   comment 'Allow Metabase'
sudo ufw allow 8080/tcp   comment 'Allow DBT Docs'
sudo ufw allow 3001/tcp   comment 'Allow Dagster'

# Reload firewall rules
sudo ufw reload

# Restart services
echo "[INFO] Restarting Grafana, Prometheus, Metabase, and Dagster..."
sudo systemctl restart grafana-server
sudo systemctl restart prometheus
sudo systemctl restart metabase

echo "[INFO] Firewall configured and services restarted."

# Starting DBT docs and Dagster UI
echo "[INFO] Starting DBT Docs on port 8080..."
dbt docs serve --host 0.0.0.0 --port 8080 &

echo "[INFO] Starting Dagster UI on port 3001..."
dagit -f ~/dagster_workspace/dbt_job.py --host 0.0.0.0 --port 3001 &

# Provide status update
echo "[INFO] Checking status of DBT Docs and Dagster services..."

curl -s http://localhost:8080 && echo "DBT Docs is up." || echo "DBT Docs is down."
curl -s http://localhost:3001 && echo "Dagster is up." || echo "Dagster is down."

echo "[SUCCESS] Setup complete and services are running."
