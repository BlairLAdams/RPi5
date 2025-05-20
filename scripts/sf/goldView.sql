-- ============================================================
-- 🧭 Gold Observation View (All Systems) - Site SF
-- ============================================================

CREATE OR REPLACE VIEW gold.vw_sf_observations AS
SELECT
  f.observation_id,
  f.source_type,
  f.observed_at,
  f.metric,
  f.value,
  f.units,
  f.status,
  f.site_code,
  f.asset_id,
  a.cmms_name,
  a.location,
  a.type AS asset_type,
  d.day_of_week,
  d.day_name,
  d.month,
  d.year,
  d.is_weekend
FROM gold.fact_sf_observations f
LEFT JOIN gold.dim_sf_cmms_assets a
  ON f.asset_id = a.asset_id
LEFT JOIN gold.dim_sf_scada_dates d
  ON f.date_key = d.date_key;
