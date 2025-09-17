with src as (
  select * from {{ ref('dataset_fashion_store_customers') }}
)
select
  customer_id::int                                   as customer_id,
  country::text                                      as country,
  age_range::text                                    as age_range,
  {{ age_bounds('age_range','min') }}                as age_min,
  {{ age_bounds('age_range','max') }}                as age_max,
  {{ date_from_text('signup_date') }}                as signup_date
from src