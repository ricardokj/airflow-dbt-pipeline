{{ config(
    materialized='incremental',
    unique_key='tailnum',
    incremental_strategy='merge'
) }}

SELECT
    tailnum,
    case when year ~ '\D' then null else year::int end AS year,
    type,
    manufacturer,
    model,
    engines,
    seats,
    case when speed ~ '\D' then null else speed::float end AS speed,
    engine
FROM {{ source('staging', 'planes') }}
