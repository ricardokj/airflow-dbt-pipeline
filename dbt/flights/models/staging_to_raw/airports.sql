{{ config(
    materialized='incremental',
    unique_key='faa',
    incremental_strategy='merge'
) }}

SELECT
    faa,
    name,
    latitude,
    longitude,
    altitude,
    timezone,
    dst,
    timezone_name
FROM {{ source('staging', 'airports') }}