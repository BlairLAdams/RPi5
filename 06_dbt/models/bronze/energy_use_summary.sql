-- ✅ Filename: models/silver/energy_use_summary.sql
-- 📦 Purpose: Summary of energy use with all relevant dimensions

{{ config(materialized='view') }}

SELECT
    f.facility_id,
    f.facility_name,  -- Dimension: Facility name
    f.facility_type,  -- Dimension: Facility type (e.g., residential, industrial)
    f.location AS facility_location,  -- Dimension: Facility location
    e.timestamp AS usage_timestamp,  -- Dimension: Timestamp of energy use
    EXTRACT(DAY FROM e.timestamp) AS usage_day,  -- Dimension: Day of usage
    EXTRACT(HOUR FROM e.timestamp) AS usage_hour,  -- Dimension: Hour of usage
    e.kwh_used,  -- Fact: Kilowatt-hours used
    e.kwh_cost,  -- Fact: Cost of energy used
    e.peak_demand,  -- Fact: Peak demand during the usage period
    e.usage_type,  -- Dimension: Type of energy use (e.g., peak, off-peak)
    e.billing_period  -- Dimension: Billing period for the energy consumption
FROM {{ source('bronze', 'energy_use') }} e
JOIN {{ ref('facilities') }} f ON e.facility_id = f.facility_id;
