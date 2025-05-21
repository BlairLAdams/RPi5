-- ============================================================
-- 🧼 SCADA | Enhanced Bronze → Silver QA Copy (Site: SF)
-- ============================================================

CREATE SCHEMA IF NOT EXISTS silver;

-- ✅ Valid SCADA rows
DROP TABLE IF EXISTS silver.sf_scada;
CREATE TABLE silver.sf_scada AS
SELECT *
FROM bronze.sf_scada
WHERE asset_id IS NOT NULL
  AND timestamp IS NOT NULL
  AND value IS NOT NULL
  AND value BETWEEN -9999 AND 9999
  AND units IN (
    'mg/L', 'NTU', 'pH', 'ft', 'gpm', '%', 'RPM', 'A', 'mL/min', 'binary'
  );

-- ❌ Failed QA rows
DROP TABLE IF EXISTS silver.qa_failed_sf_scada;
CREATE TABLE silver.qa_failed_sf_scada AS
SELECT *
FROM bronze.sf_scada
WHERE asset_id IS NULL
   OR timestamp IS NULL
   OR value IS NULL
   OR value NOT BETWEEN -9999 AND 9999
   OR units NOT IN (
     'mg/L', 'NTU', 'pH', 'ft', 'gpm', '%', 'RPM', 'A', 'mL/min', 'binary'
   );
