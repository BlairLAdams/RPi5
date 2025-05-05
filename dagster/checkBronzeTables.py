#!/usr/bin/env python3
# ✅ Filename: checkBronzeTables.py
# 📦 Purpose: Interactively inspect bronze-layer tables in PostgreSQL
# 🔐 Prompts for username and password securely
# 🧠 Style: Drop-in, production-ready

import getpass
from sqlalchemy import create_engine, text

# ─────────────────────────────────────────────────────────────────────────────
# 🔐 Prompt for credentials
# ─────────────────────────────────────────────────────────────────────────────
pg_user = input("👤 Enter Postgres username: ")
pg_pw = getpass.getpass(f"🔑 Enter Postgres password for user '{pg_user}': ")

# ─────────────────────────────────────────────────────────────────────────────
# 🧱 Connect to PostgreSQL and list bronze tables
# ─────────────────────────────────────────────────────────────────────────────
print("🔎 Connecting to Postgres to inspect bronze tables...")
pg_uri = f"postgresql://{pg_user}:{pg_pw}@localhost:5432/postgres"
pg_engine = create_engine(pg_uri)

with pg_engine.connect() as conn:
    result = conn.execute(text(
        """
        SELECT table_schema, table_name
        FROM information_schema.tables
        WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
        ORDER BY table_schema, table_name;
        """
    ))
    print("\n📋 Bronze tables in Postgres:")
    for row in result:
        print(f" - {row.table_schema}.{row.table_name}")
