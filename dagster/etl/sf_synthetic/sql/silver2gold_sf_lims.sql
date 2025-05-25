-- ============================================================
-- 🟥 silver2gold_sf_lims.sql — LIMS to Gold Layer
-- ============================================================

CREATE SCHEMA IF NOT EXISTS gold;

-- 📊 Fact Table: LIMS Observations
DROP TABLE IF EXISTS gold.fact_sf_lims_observations;
CREATE TABLE gold.fact_sf_lims_observations AS
SELECT
  gen_random_uuid() AS observation_id,
  NULL::TEXT AS asset_id,
  'LIMS' AS source_type,
  sample_time::TIMESTAMP AS observed_at,
  sample_time::DATE AS observed_date,
  sample_time::TIME AS observed_time,
  analyte::TEXT AS metric,
  value::NUMERIC AS value,
  units::TEXT AS units,
  NULL::TEXT AS status,
  site_code::TEXT AS site_code
FROM silver.sf_lims;

ALTER TABLE gold.fact_sf_lims_observations
ADD COLUMN date_key DATE GENERATED ALWAYS AS (observed_at::date) STORED;

-- No FK constraint to assets (asset_id is NULL for LIMS)
-- Optional: FK to gold.dim_sf_scada_dates if needed
CREATE INDEX IF NOT EXISTS idx_fact_lims_date_key ON gold.fact_sf_lims_observations (date_key);

ALTER TABLE gold.fact_sf_lims_observations
ADD CONSTRAINT fk_lims_date
FOREIGN KEY (date_key)
REFERENCES gold.dim_sf_scada_dates(date_key)
ON DELETE CASCADE;
