

WITH source_data AS (
    SELECT
        "Site" AS site,
        TO_DATE(SUBSTRING("Collect DateTime", 1, 10), 'MM/DD/YYYY') AS sample_date,
        "Parameter",
        "Value",
        "Units"
    FROM bronze_wq.water_quality
    WHERE "Value" IS NOT NULL
),

pivoted_data AS (
    SELECT
        site,
        sample_date,
        MAX(CASE WHEN LOWER("Parameter") = 'ph' THEN "Value" END) AS pH,
        MAX(CASE WHEN LOWER("Parameter") = 'turbidity' THEN "Value" END) AS turbidity,
        MAX(CASE WHEN LOWER("Parameter") = 'dissolved oxygen' THEN "Value" END) AS dissolved_oxygen,
        MAX(CASE WHEN LOWER("Parameter") = 'conductivity' THEN "Value" END) AS conductivity,
        MAX(CASE WHEN LOWER("Parameter") = 'temperature' THEN "Value" END) AS temperature,
        MAX(CASE WHEN LOWER("Parameter") = 'coliform' THEN "Value" END) AS coliform
    FROM source_data
    GROUP BY site, sample_date
)

SELECT * FROM pivoted_data