-- ✅ Filename: silver/wq_summary.sql
-- 📦 Purpose: Summary of water quality with maximum dimensions

with enriched as (
    select
        "Sample ID",
        "Grab ID",
        "Profile ID",
        "Sample Number",
        "Collect DateTime",
        "Depth (m)",
        "Site Type",
        "Area",
        "Locator",
        "Site",
        "Parameter",
        "Value",
        "Units",
        "QualityId",
        "Lab Qualifier",
        "MDL",
        "RDL",
        "Text Value",
        "Sample Info",
        "Steward Note",
        "Replicates",
        "Replicate Of",
        "Method",
        "Date Analyzed",
        "Data Source"
    from {{ source('bronze', 'water_quality') }}
    where "Value" is not null
)

select * from enriched
