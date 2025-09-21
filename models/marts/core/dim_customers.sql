with base as (
  select
    customer_id,
    country,
    age_range,
    {{ age_bounds('age_range','min') }} as age_min,
    {{ age_bounds('age_range','max') }} as age_max,
    signup_date
  from {{ ref('stg_customers') }}
)
select * from base
union all
select
  -1::int         as customer_id,
  'Unknown'::text as country,
  null::text       as age_range,
  null::int       as age_min,
  null::int       as age_max,
  null::date      as signup_date