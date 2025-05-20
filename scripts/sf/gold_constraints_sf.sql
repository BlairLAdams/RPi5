-- ============================================================
-- 🔒 Add Primary & Foreign Key Constraints to Gold Layer - Site SF
-- ============================================================

-- ----------------------------------------------------------------
-- 🧱 Ensure Primary Keys on Dimension Tables
-- ----------------------------------------------------------------

-- Add PK to dim_sf_cmms_assets
ALTER TABLE gold.dim_sf_cmms_assets
  ADD CONSTRAINT pk_dim_assets PRIMARY KEY (asset_id);

-- Add PK to dim_sf_scada_dates
ALTER TABLE gold.dim_sf_scada_dates
  ADD CONSTRAINT pk_dim_dates PRIMARY KEY (date_key);

-- ----------------------------------------------------------------
-- 🧩 Indexes for FK Join Performance (Optional if PK exists)
-- ----------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_dim_assets_asset_id
  ON gold.dim_sf_cmms_assets (asset_id);

CREATE INDEX IF NOT EXISTS idx_dim_dates_date_key
  ON gold.dim_sf_scada_dates (date_key);

-- ----------------------------------------------------------------
-- 🔗 Foreign Key Constraints for fact_sf_observations
-- ----------------------------------------------------------------

-- Ensure derived column exists
ALTER TABLE gold.fact_sf_observations
  ADD COLUMN IF NOT EXISTS date_key DATE GENERATED ALWAYS AS (observed_at::date) STORED;

-- FK to asset_id (nullable — LIMS rows allowed)
ALTER TABLE gold.fact_sf_observations
  ADD CONSTRAINT fk_fact_asset
  FOREIGN KEY (asset_id)
  REFERENCES gold.dim_sf_cmms_assets(asset_id)
  ON DELETE SET NULL;

-- FK to date dimension
ALTER TABLE gold.fact_sf_observations
  ADD CONSTRAINT fk_fact_date
  FOREIGN KEY (date_key)
  REFERENCES gold.dim_sf_scada_dates(date_key)
  ON DELETE CASCADE;
