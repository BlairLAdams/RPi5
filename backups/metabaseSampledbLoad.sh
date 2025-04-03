#!/bin/bash
# Loads sample Metabase tutorial dataset into PostgreSQL

set -e

echo "[*] Loading sample Metabase dataset into PostgreSQL sampledb..."

PGPASSWORD=metabase psql -U metabase -h localhost -d sampledb <<'EOF'
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT,
    price NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS people (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    user_id INTEGER REFERENCES people(id),
    quantity INTEGER,
    created_at TIMESTAMP DEFAULT now()
);

INSERT INTO products (title, category, price) VALUES
('Sunscreen SPF 50', 'Health & Beauty', 12.99),
('Yoga Mat', 'Fitness', 29.95),
('Running Shoes', 'Footwear', 89.99)
ON CONFLICT DO NOTHING;

INSERT INTO people (name, email) VALUES
('Alice Example', 'alice@example.com'),
('Bob Example', 'bob@example.com'),
('Carol Example', 'carol@example.com')
ON CONFLICT DO NOTHING;

INSERT INTO orders (product_id, user_id, quantity, created_at) VALUES
(1, 1, 2, '2024-01-01 10:00:00'),
(2, 2, 1, '2024-01-03 11:30:00'),
(3, 3, 1, '2024-01-05 13:45:00')
ON CONFLICT DO NOTHING;
EOF

echo "[*] Sample dataset loaded. Open Metabase and connect to 'sampledb'."
