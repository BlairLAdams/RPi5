-- ✅ Filename: bronze/measurements.sql
-- 📦 Purpose: Simple passthrough or filtered views of actual bronze-layer data

-- Example 1: Mirror water_quality as-is
select * from {{ source('bronze', 'water_quality') }}

