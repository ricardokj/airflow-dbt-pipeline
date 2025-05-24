{{ 
  config(
    materialized='incremental',
    unique_key=['origin', 'year', 'month', 'day', 'hour'],
    incremental_strategy='merge'
  ) 
}}

with latest_record as (
    select 
        *,
        row_number() over (partition by origin, year, month, day, hour order by time_hour desc nulls last) as rn
    from {{ source('staging', 'weather') }}
)
select
    origin,
    year,
    month,
    day,
    hour,
    case when temp ~ '\D' then null else temp::numeric end as temp,
    case when dewp ~ '\D' then null else dewp::numeric end as dewp,
    case when humid ~ '\D' then null else humid::numeric end as humid,
    case when wind_dir ~ '\D' then null else wind_dir::float end as wind_dir,
    case when wind_speed ~ '\D' then null else wind_speed::numeric end as wind_speed,
    case when wind_gust ~ '\D' then null else wind_gust::numeric end as wind_gust,
    precip,
    case when pressure ~ '\D' then null else pressure::numeric end as pressure,
    visib,  
    time_hour
from latest_record
where rn = 1