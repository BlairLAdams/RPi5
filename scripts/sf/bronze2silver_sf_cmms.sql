-- ============================================================
-- 🛠 CMMS | Enhanced Bronze → Silver QA Copy (Site: SF)
-- ============================================================

CREATE SCHEMA IF NOT EXISTS silver;

-- ✅ Valid CMMS rows
DROP TABLE IF EXISTS silver.sf_cmms;
CREATE TABLE silver.sf_cmms AS
SELECT *
FROM bronze.sf_cmms
WHERE asset_id IS NOT NULL
  AND opened_date IS NOT NULL
  AND work_type IN ('Preventive','Corrective','Inspection','Calibration','Emergency')
  AND cost IS NOT NULL AND cost >= 0;

-- ❌ Failed QA rows
DROP TABLE IF EXISTS silver.qa_failed_sf_cmms;
CREATE TABLE silver.qa_failed_sf_cmms AS
SELECT *
FROM bronze.sf_cmms
WHERE asset_id IS NULL
   OR opened_date IS NULL
   OR work_type NOT IN ('Preventive','Corrective','Inspection','Calibration','Emergency')
   OR cost IS NULL OR cost < 0;
