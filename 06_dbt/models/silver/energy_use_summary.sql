-- ✅ Filename: silver/energy_use_summary.sql
-- 📦 Purpose: Retain full granularity of energy + weather readings

with enriched as (
    select
        "Datetime",
        "Temperature",
        "Humidity",
        "WindSpeed",
        "GeneralDiffuseFlows",
        "DiffuseFlows",
        "PowerConsumption_Zone1",
        "PowerConsumption_Zone2",
        "PowerConsumption_Zone3"
    from {{ source('bronze', 'energy_use') }}
)

select * from enriched
