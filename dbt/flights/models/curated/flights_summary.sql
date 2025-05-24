SELECT
    carrier,
    year,
    month,
    COUNT(*) AS total_flights,
    AVG(dep_delay) AS avg_dep_delay,
    AVG(arr_delay) AS avg_arr_delay
FROM {{ source('raw_data','flights') }}
GROUP BY carrier, year, month
ORDER BY carrier, year, month