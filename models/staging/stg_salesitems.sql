with src as (
  select * from {{ ref('dataset_fashion_store_salesitems') }}
)
select
  item_id::int                                   as item_id,
  sale_id::int                                   as sale_id,
  product_id::int                                as product_id,
  quantity::int                                  as quantity,
  {{ money_to_numeric('original_price') }}::numeric(12,2) as original_price,
  {{ money_to_numeric('unit_price') }}::numeric(12,2)     as unit_price,
  {{ money_to_numeric('discount_applied') }}::numeric(12,2) as discount_applied,
  {{ pct_to_decimal('discount_percent') }}        as discount_pct,
  (discounted::int = 1)                           as is_discounted,
  {{ money_to_numeric('item_total') }}::numeric(12,2)    as item_total,
  {{ date_from_text('sale_date') }}               as sale_date,
  channel::text                                   as channel,
  channel_campaigns::text                         as channel_campaigns
from src