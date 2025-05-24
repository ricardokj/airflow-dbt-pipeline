{{ config(
    materialized='incremental',
    unique_key='carrier',
    incremental_strategy='merge'
) }}

select
    carrier,
    name
from {{ source('staging', 'airlines') }}
