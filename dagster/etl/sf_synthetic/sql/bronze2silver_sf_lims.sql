-- ============================================================
-- 🧪 LIMS | Enhanced Bronze → Silver QA Copy (Site: SF)
-- ============================================================

CREATE SCHEMA IF NOT EXISTS silver;

-- ✅ Valid LIMS rows
DROP TABLE IF EXISTS silver.sf_lims;
CREATE TABLE silver.sf_lims AS
SELECT *
FROM bronze.sf_lims
WHERE analyte IN ('Chlorine','Turbidity','pH')
  AND value IS NOT NULL
  AND (
    (analyte = 'pH' AND value BETWEEN 0 AND 14)
    OR (analyte != 'pH')
  )
  AND sample_time IS NOT NULL;

-- ❌ Failed QA rows
DROP TABLE IF EXISTS silver.qa_failed_sf_lims;
CREATE TABLE silver.qa_failed_sf_lims AS
SELECT *
FROM bronze.sf_lims
WHERE analyte NOT IN ('Chlorine','Turbidity','pH')
   OR value IS NULL
   OR (analyte = 'pH' AND value NOT BETWEEN 0 AND 14)
   OR sample_time IS NULL;
