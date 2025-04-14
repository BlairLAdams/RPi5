#!/bin/bash
# ✅ Filename: inspectSchemaDeps.sh
# 📦 Purpose: Safely inspect object-level dependencies on a given PostgreSQL schema

read -p "🖥️  Enter PostgreSQL host (default 'localhost'): " host
host=${host:-localhost}

read -p "🔌 Enter PostgreSQL port (default 5432): " port
port=${port:-5432}

read -p "📚 Enter database name (default 'metadb'): " dbname
dbname=${dbname:-metadb}

read -p "👤 Enter PostgreSQL username: " user
read -s -p "🔑 Enter PostgreSQL password: " password
echo ""

read -p "📂 Enter schema name to inspect: " schema

echo "🔍 Inspecting dependencies on schema '$schema'..."

query=$(cat <<EOF_SQL
WITH schema_oid AS (
  SELECT oid FROM pg_namespace WHERE nspname = '$schema'
)
SELECT
  CASE c.relkind
    WHEN 'r' THEN 'TABLE'
    WHEN 'v' THEN 'VIEW'
    WHEN 'm' THEN 'MATERIALIZED VIEW'
    WHEN 'S' THEN 'SEQUENCE'
    WHEN 'f' THEN 'FOREIGN TABLE'
    ELSE c.relkind
  END AS object_type,
  n.nspname AS schema,
  c.relname AS object_name,
  d.deptype AS dependency_type,
  d.refobjid::regclass AS referenced_by
FROM
  pg_depend d
JOIN
  pg_class c ON d.objid = c.oid
JOIN
  pg_namespace n ON c.relnamespace = n.oid
WHERE
  d.refobjid IN (
    SELECT oid FROM pg_class WHERE relnamespace = (SELECT oid FROM schema_oid)
  )
ORDER BY 1, 3;
EOF_SQL
)

PGPASSWORD="$password" psql -h "$host" -p "$port" -U "$user" -d "$dbname" -c "$query"
