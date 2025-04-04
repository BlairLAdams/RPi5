#!/bin/bash
# DBT Profile Setup for PostgreSQL

set -e

# Ask for user input to configure PostgreSQL connection
echo "🔧 Please enter the PostgreSQL username:"
read -r postgres_user

echo "🔧 Please enter the PostgreSQL password:"
read -s postgres_password

echo "🔧 Please enter the PostgreSQL database name:"
read -r postgres_dbname

echo "🔧 Please enter the PostgreSQL host (default is 'localhost'):"
read -r postgres_host
postgres_host="${postgres_host:-localhost}"  # Default to localhost if not provided

echo "🔧 Please enter the PostgreSQL port (default is 5432):"
read -r postgres_port
postgres_port="${postgres_port:-5432}"  # Default to 5432 if not provided

# Create or update the profiles.yml file in ~/.dbt/
profiles_dir=~/.dbt
mkdir -p "$profiles_dir"

cat > "$profiles_dir/profiles.yml" <<EOL
openstack_project:
  target: dev
  outputs:
    dev:
      type: postgres
      host: $postgres_host
      user: $postgres_user
      password: $postgres_password
      dbname: $postgres_dbname
      port: $postgres_port
      schema: public
      threads: 1
      keepalives_idle: 0
EOL

echo "✅ PostgreSQL profile for DBT has been configured."

# Automatically continue with DBT Docs
continue_docs="y"

if [[ "$continue_docs" == "y" || "$continue_docs" == "Y" ]]; then
  # Change to the directory containing the dbt_project.yml
  echo "🔧 Changing to the Pagila project directory..."
  cd ~/dbt/pagila_project

  # Create rentals_summary.sql with the correct SQL
  echo "📄 Creating the SQL model for rentals_summary..."
  mkdir -p models
  cat > models/rentals_summary.sql <<'EOF'
SELECT customer_id, COUNT(*) AS total_rentals
FROM rental
GROUP BY customer_id
ORDER BY total_rentals DESC
LIMIT 10;
EOF

  # Run dbt to generate necessary files and the target directory
  echo "🚀 Running DBT transformations to generate necessary files..."
  dbt run --profiles-dir ~/.dbt

  # Start DBT Docs server
  echo "🚀 Starting DBT Docs server..."
  dbt docs serve --port 8080
else
  echo "✅ DBT Docs setup skipped."
fi
