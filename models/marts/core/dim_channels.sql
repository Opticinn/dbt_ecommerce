{{ config(materialized='table', schema='marts') }}

with seed_base as (
  select channel::text, description::text
  from {{ ref('dataset_fashion_store_channels') }}
),
from_sales as (
  select distinct channel::text as channel, null::text as description
  from {{ ref('stg_sales') }}
),
from_campaigns as (
  select distinct {{ normalize_channel('channel') }} as channel, null::text as description
  from {{ ref('stg_campaigns') }}
),
unioned as (
  select * from seed_base
  union
  select * from from_sales
  union
  select * from from_campaigns
),
dedup as (
  select
    channel,
    coalesce(
      max(description) filter (where description is not null),
      case
        when channel = 'App Mobile'   then 'Mobile app sales'
        when channel = 'Website'      then 'Website sales'
        when channel = 'Email'        then 'Email campaigns'
        when channel = 'Social Media' then 'Social media ads'
        else 'Other / unspecified'
      end
    ) as description
  from unioned
  group by channel
)
select channel, description
from dedup
