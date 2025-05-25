-- ============================================================
-- 🟩 silver2gold_sf_cmms.sql — CMMS to Gold Layer
-- ============================================================

CREATE SCHEMA IF NOT EXISTS gold;

-- 📦 Dimension: CMMS Assets
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

-- 📊 Fact Table: CMMS Observations
DROP TABLE IF EXISTS gold.fact_sf_cmms_observations;
CREATE TABLE gold.fact_sf_cmms_observations AS
SELECT
  gen_random_uuid() AS observation_id,
  asset_id::TEXT AS asset_id,
  'CMMS' AS source_type,
  opened_date::TIMESTAMP AS observed_at,
  opened_date::DATE AS observed_date,
  opened_date::TIME AS observed_time,
  work_type::TEXT AS metric,
  cost::NUMERIC AS value,
  'USD' AS units,
  status::TEXT AS status,
  site_code::TEXT AS site_code
FROM silver.sf_cmms;

ALTER TABLE gold.fact_sf_cmms_observations
ADD COLUMN date_key DATE GENERATED ALWAYS AS (observed_at::date) STORED;

-- 🔗 FK Constraints
CREATE INDEX IF NOT EXISTS idx_fact_cmms_asset_id ON gold.fact_sf_cmms_observations (asset_id);

ALTER TABLE gold.fact_sf_cmms_observations
ADD CONSTRAINT fk_cmms_asset
FOREIGN KEY (asset_id)
REFERENCES gold.dim_sf_cmms_assets(asset_id)
ON DELETE SET NULL;
