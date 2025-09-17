{{ config(materialized='table', schema='marts') }}

with bounds as (
  select
    least(
      (select min(sale_date) from {{ ref('stg_sales') }}),
      (select min(sale_date) from {{ ref('stg_salesitems') }})
    ) as min_date,
    greatest(
      (select max(sale_date) from {{ ref('stg_sales') }}),
      (select max(sale_date) from {{ ref('stg_salesitems') }})
    ) as max_date
),
series as (
  select generate_series(min_date, max_date, interval '1 day')::date as dt
  from bounds
)
select
  (extract(year from dt)::int * 10000
   + extract(month from dt)::int * 100
   + extract(day from dt)::int)                   as date_key,
  dt                                              as date,
  extract(year from dt)::int                      as year,
  extract(quarter from dt)::int                   as quarter,
  extract(month from dt)::int                     as month,
  to_char(dt, 'Month')                            as month_name,
  to_char(dt, 'Mon')                              as month_short,
  extract(day from dt)::int                       as day_of_month,
  extract(isodow from dt)::int                    as iso_dow,
  to_char(dt, 'Day')                              as day_name,
  (extract(isodow from dt) in (6,7))              as is_weekend,
  to_char(dt, 'IYYY-IW')                          as iso_week,
  date_trunc('week', dt)::date                    as week_start,
  (date_trunc('week', dt) + interval '6 day')::date as week_end,
  date_trunc('month', dt)::date                   as month_start,
  (date_trunc('month', dt) + interval '1 month - 1 day')::date as month_end,
  to_char(dt, 'YYYY-MM')                          as ym_label
from series
order by dt
