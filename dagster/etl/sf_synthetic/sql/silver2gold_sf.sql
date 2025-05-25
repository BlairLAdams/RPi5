-- ============================================================
-- 🎯 Create Gold Star Schema for Site SF with Constraints
-- ============================================================

CREATE SCHEMA IF NOT EXISTS gold;

-- ----------------------------------------------------------------
-- 📦 Dimension: CMMS Asset
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_sf_cmms_assets;
CREATE TABLE gold.dim_sf_cmms_assets AS
SELECT DISTINCT
  asset_id,
  cmms_name,
  location,
  type
FROM silver.sf_cmms;

ALTER TABLE gold.dim_sf_cmms_assets
ADD CONSTRAINT pk_dim_assets PRIMARY KEY (asset_id);

-- ----------------------------------------------------------------
-- 📅 Dimension: SCADA Dates
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_sf_scada_dates;
CREATE TABLE gold.dim_sf_scada_dates AS
SELECT
  date::date AS date_key,
  date::date AS date,
  EXTRACT(DOW FROM date) AS day_of_week,
  TO_CHAR(date, 'Day') AS day_name,
  EXTRACT(MONTH FROM date) AS month,
  EXTRACT(YEAR FROM date) AS year,
  CASE WHEN EXTRACT(DOW FROM date) IN (0,6) THEN true ELSE false END AS is_weekend
FROM (
  SELECT generate_series('2024-01-01'::date, '2024-12-31'::date, '1 day') AS date
) d;

ALTER TABLE gold.dim_sf_scada_dates
ADD CONSTRAINT pk_dim_dates PRIMARY KEY (date_key);

-- ----------------------------------------------------------------
-- 📊 Fact: Unified Observations (SCADA + CMMS + LIMS)
-- ----------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

DROP TABLE IF EXISTS gold.fact_sf_observations;
CREATE TABLE gold.fact_sf_observations AS

-- SCADA
SELECT
  gen_random_uuid() AS observation_id,
  asset_id::TEXT AS asset_id,
  'SCADA' AS source_type,
  timestamp::TIMESTAMP AS observed_at,
  tag_name::TEXT AS metric,
  value::NUMERIC AS value,
  units::TEXT AS units,
  status::TEXT AS status,
  site_code::TEXT AS site_code
FROM silver.sf_scada

UNION ALL

-- CMMS
SELECT
  gen_random_uuid() AS observation_id,
  asset_id::TEXT AS asset_id,
  'CMMS' AS source_type,
  opened_date::TIMESTAMP AS observed_at,
  work_type::TEXT AS metric,
  cost::NUMERIC AS value,
  'USD' AS units,
  status::TEXT AS status,
  site_code::TEXT AS site_code
FROM silver.sf_cmms

UNION ALL

-- LIMS
SELECT
  gen_random_uuid() AS observation_id,
  NULL::TEXT AS asset_id,
  'LIMS' AS source_type,
  sample_time::TIMESTAMP AS observed_at,
  analyte::TEXT AS metric,
  value::NUMERIC AS value,
  units::TEXT AS units,
  NULL::TEXT AS status,
  site_code::TEXT AS site_code
FROM silver.sf_lims;

-- Add derived date_key column for FK reference
ALTER TABLE gold.fact_sf_observations
ADD COLUMN date_key DATE GENERATED ALWAYS AS (observed_at::date) STORED;
