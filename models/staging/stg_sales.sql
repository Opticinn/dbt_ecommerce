with src as (
  select * from {{ ref('dataset_fashion_store_sales') }}
)
select
  sale_id::int                                 as sale_id,
  channel::text                                as channel,
  (discounted::int = 1)                        as is_discounted,
  {{ money_to_numeric('total_amount') }}::numeric(12,2) as total_amount,
  {{ date_from_text('sale_date') }}            as sale_date,
  customer_id::int                              as customer_id,
  country::text                                 as country
from src