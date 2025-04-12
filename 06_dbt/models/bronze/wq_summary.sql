-- ✅ Filename: models/silver/wq_summary.sql
-- 📦 Purpose: Full summary of water quality with maximum dimensions

{{ config(materialized='view') }}

WITH enriched AS (
    SELECT
        "Sample ID",  -- Dimension: Sample identifier
        "Grab ID",  -- Dimension: Grab sample identifier
        "Profile ID",  -- Dimension: Profile identifier
        "Sample Number",  -- Dimension: Sample number
        "Collect DateTime",  -- Dimension: Sample collection timestamp
        "Depth (m)",  -- Dimension: Depth at sample collection
        "Site Type",  -- Dimension: Type of site (e.g., river, lake)
        "Area",  -- Dimension: Geographic area of sampling
        "Locator",  -- Dimension: Locator (location identifier)
        "Site",  -- Dimension: Site name
        "Parameter",  -- Dimension: Measurement parameter (e.g., pH, turbidity)
        "Value",  -- Fact: Value of the measurement
        "Units",  -- Dimension: Units of measurement (e.g., mg/L)
        "QualityId",  -- Dimension: Quality identifier (e.g., data quality)
        "Lab Qualifier",  -- Dimension: Qualifiers from the lab report
        "MDL",  -- Dimension: Method detection limit (MDL)
        "RDL",  -- Dimension: Reporting detection limit (RDL)
        "Text Value",  -- Dimension: Text representation of the value
        "Sample Info",  -- Dimension: Additional sample information
        "Steward Note",  -- Dimension: Steward’s note on the sample
        "Replicates",  -- Dimension: Number of replicates for the sample
        "Replicate Of",  -- Dimension: Original sample that replicates are based on
        "Method",  -- Dimension: Method of analysis
        "Date Analyzed",  -- Dimension: Date sample was analyzed
        "Data Source"  -- Dimension: Source of the data (e.g., field collection, lab)
    FROM {{ source('bronze', 'water_quality') }}
    WHERE "Value" IS NOT NULL
)

SELECT * FROM enriched;
