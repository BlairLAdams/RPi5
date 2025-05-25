-- ============================================================
-- 🟦 silver2gold_sf_scada.sql — SCADA to Gold Layer
-- ============================================================

CREATE SCHEMA IF NOT EXISTS gold;

-- 📅 Dimension: SCADA Dates
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

-- 📊 Fact Table: SCADA Observations
DROP TABLE IF EXISTS gold.fact_sf_scada_observations;
CREATE TABLE gold.fact_sf_scada_observations AS
SELECT
  gen_random_uuid() AS observation_id,
  asset_id::TEXT AS asset_id,
  'SCADA' AS source_type,
  timestamp::TIMESTAMP AS observed_at,
  timestamp::DATE AS observed_date,
  timestamp::TIME AS observed_time,
  tag_name::TEXT AS metric,
  value::NUMERIC AS value,
  units::TEXT AS units,
  status::TEXT AS status,
  site_code::TEXT AS site_code
FROM silver.sf_scada;

ALTER TABLE gold.fact_sf_scada_observations
ADD COLUMN date_key DATE GENERATED ALWAYS AS (observed_at::date) STORED;

-- 🔗 FK Constraints
CREATE INDEX IF NOT EXISTS idx_fact_scada_date_key ON gold.fact_sf_scada_observations (date_key);

ALTER TABLE gold.fact_sf_scada_observations
ADD CONSTRAINT fk_scada_date
FOREIGN KEY (date_key)
REFERENCES gold.dim_sf_scada_dates(date_key)
ON DELETE CASCADE;
