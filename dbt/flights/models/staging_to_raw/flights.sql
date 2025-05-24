{{ 
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['carrier', 'flight', 'year', 'month', 'day', 'hour', 'minute']
  ) 
}}

select
    carrier,
    flight,
    year,
    month,
    day,
    hour,
    minute,
    actual_dep_time,
    sched_dep_time,
    dep_delay,
    actual_arr_time,
    sched_arr_time,
    arr_delay,
    tailnum,
    origin,
    dest,
    air_time,
    distance,
    time_hour
from {{ source('staging','flights') }}
