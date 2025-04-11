-- 🧱 Filename: daily_station_summary.sql
-- 📦 Purpose: Aggregated WQ measurements per station per day

SELECT
    s.station_id,
    s.station_name,
    m.sample_date::date AS sample_day,
    a.analyte_name,
    ROUND(AVG(m.value), 2) AS avg_value,
    COUNT(*) AS num_measurements
FROM measurements m
JOIN stations s ON m.station_id = s.station_id
JOIN analytes a ON m.analyte_id = a.analyte_id
GROUP BY s.station_id, s.station_name, m.sample_date::date, a.analyte_name
ORDER BY s.station_id, sample_day, a.analyte_name;

