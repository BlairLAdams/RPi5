

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
        MAX(CASE WHEN LOWER("Parameter") = 'ammonia nitrogen' THEN "Value" END) AS ammonia_nitrogen,
        MAX(CASE WHEN LOWER("Parameter") = 'bga pc  field' THEN "Value" END) AS bga_pc_field,
        MAX(CASE WHEN LOWER("Parameter") = 'biochemical oxygen demand' THEN "Value" END) AS bod,
        MAX(CASE WHEN LOWER("Parameter") = 'chlorophyll a' THEN "Value" END) AS chlorophyll_a,
        MAX(CASE WHEN LOWER("Parameter") = 'chlorophyll  field' THEN "Value" END) AS chlorophyll_field,
        MAX(CASE WHEN LOWER("Parameter") = 'conductivity' THEN "Value" END) AS conductivity,
        MAX(CASE WHEN LOWER("Parameter") = 'conductivity  field' THEN "Value" END) AS conductivity_field,
        MAX(CASE WHEN LOWER("Parameter") = 'density' THEN "Value" END) AS density,
        MAX(CASE WHEN LOWER("Parameter") = 'dissolved organic carbon' THEN "Value" END) AS doc,
        MAX(CASE WHEN LOWER("Parameter") = 'dissolved oxygen' THEN "Value" END) AS dissolved_oxygen,
        MAX(CASE WHEN LOWER("Parameter") = 'dissolved oxygen  field' THEN "Value" END) AS dissolved_oxygen_field,
        MAX(CASE WHEN LOWER("Parameter") = 'dissolved oxygen saturation  field' THEN "Value" END) AS do_saturation_field,
        MAX(CASE WHEN LOWER("Parameter") = 'e. coli' THEN "Value" END) AS ecoli,
        MAX(CASE WHEN LOWER("Parameter") = 'enterococcus' THEN "Value" END) AS enterococcus,
        MAX(CASE WHEN LOWER("Parameter") = 'fecal coliform' THEN "Value" END) AS fecal_coliform,
        MAX(CASE WHEN LOWER("Parameter") = 'fecal streptococcus' THEN "Value" END) AS fecal_streptococcus,
        MAX(CASE WHEN LOWER("Parameter") = 'hardness  calc' THEN "Value" END) AS hardness_calc,
        MAX(CASE WHEN LOWER("Parameter") = 'light intensity (par)' THEN "Value" END) AS par_intensity,
        MAX(CASE WHEN LOWER("Parameter") = 'light transmissivity' THEN "Value" END) AS light_transmissivity,
        MAX(CASE WHEN LOWER("Parameter") = 'nitrate nitrogen' THEN "Value" END) AS nitrate_nitrogen,
        MAX(CASE WHEN LOWER("Parameter") = 'nitrite + nitrate nitrogen' THEN "Value" END) AS nitrite_nitrate_nitrogen,
        MAX(CASE WHEN LOWER("Parameter") = 'nitrite nitrogen' THEN "Value" END) AS nitrite_nitrogen,
        MAX(CASE WHEN LOWER("Parameter") = 'organic nitrogen' THEN "Value" END) AS organic_nitrogen,
        MAX(CASE WHEN LOWER("Parameter") = 'orthophosphate phosphorus' THEN "Value" END) AS ortho_phosphate,
        MAX(CASE WHEN LOWER("Parameter") = 'ph' THEN "Value" END) AS ph,
        MAX(CASE WHEN LOWER("Parameter") = 'pheophytin a' THEN "Value" END) AS pheophytin_a,
        MAX(CASE WHEN LOWER("Parameter") = 'ph  field' THEN "Value" END) AS ph_field,
        MAX(CASE WHEN LOWER("Parameter") = 'salinity' THEN "Value" END) AS salinity,
        MAX(CASE WHEN LOWER("Parameter") = 'salinity  field' THEN "Value" END) AS salinity_field,
        MAX(CASE WHEN LOWER("Parameter") = 'sampling method' THEN "Value" END) AS sampling_method,
        MAX(CASE WHEN LOWER("Parameter") = 'secchi transparency' THEN "Value" END) AS secchi_transparency,
        MAX(CASE WHEN LOWER("Parameter") = 'settleable solids  gravimetric' THEN "Value" END) AS settleable_solids,
        MAX(CASE WHEN LOWER("Parameter") = 'silica' THEN "Value" END) AS silica,
        MAX(CASE WHEN LOWER("Parameter") = 'storm or non-storm' THEN "Value" END) AS storm_flag,
        MAX(CASE WHEN LOWER("Parameter") = 'surface light intensity (par)' THEN "Value" END) AS surface_par,
        MAX(CASE WHEN LOWER("Parameter") = 'temperature' THEN "Value" END) AS temperature,
        MAX(CASE WHEN LOWER("Parameter") = 'total alkalinity' THEN "Value" END) AS total_alkalinity,
        MAX(CASE WHEN LOWER("Parameter") = 'total coliform' THEN "Value" END) AS total_coliform,
        MAX(CASE WHEN LOWER("Parameter") = 'total hydrolyzable phosphorus' THEN "Value" END) AS thp,
        MAX(CASE WHEN LOWER("Parameter") = 'total kjeldahl nitrogen' THEN "Value" END) AS tkn,
        MAX(CASE WHEN LOWER("Parameter") = 'total nitrogen' THEN "Value" END) AS total_nitrogen,
        MAX(CASE WHEN LOWER("Parameter") = 'total organic carbon' THEN "Value" END) AS toc,
        MAX(CASE WHEN LOWER("Parameter") = 'total phosphorus' THEN "Value" END) AS total_phosphorus,
        MAX(CASE WHEN LOWER("Parameter") = 'total suspended solids' THEN "Value" END) AS tss,
        MAX(CASE WHEN LOWER("Parameter") = 'turbidity' THEN "Value" END) AS turbidity,
        MAX(CASE WHEN LOWER("Parameter") = 'turbidity  field' THEN "Value" END) AS turbidity_field,
        MAX(CASE WHEN LOWER("Parameter") = 'volatile suspended solids' THEN "Value" END) AS vss
    FROM source_data
    GROUP BY site, sample_date
)

SELECT * FROM pivoted_data