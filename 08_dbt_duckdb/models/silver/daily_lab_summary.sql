-- ✅ Filename: daily_lab_summary.sql
-- 📦 Purpose: Aggregate lab result values by day, station, and parameter

SELECT
  date_trunc('day', collect_datetime) AS sample_date,
  site AS station_id,
  parameter AS analyte,
  AVG(value) AS avg_result,
  MIN(value) AS min_result,
  MAX(value) AS max_result,
  COUNT(*) AS sample_count
FROM read_parquet('../../data/bronze/lab_results.parquet')
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3
