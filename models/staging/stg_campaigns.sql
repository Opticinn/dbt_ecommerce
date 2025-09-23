with src as (
  select * from {{ ref('dataset_fashion_store_campaigns') }}
)
select
  campaign_id::int                         as campaign_id,
  campaign_name::text                      as campaign_name,
  {{ date_from_text('start_date') }}       as start_date,
  {{ date_from_text('end_date') }}         as end_date,
  channel::text                            as channel,          -- asli
  {{ normalize_channel('channel') }}       as channel_norm,     -- normalisasi
  discount_type::text                      as discount_type,
  {{ pct_to_decimal('discount_value') }}   as discount_value
from src
