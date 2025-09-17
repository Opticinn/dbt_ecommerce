-- marts/core/dim_campaigns.sql
-- Grain: one row per campaign_id
select
  campaign_id,
  campaign_name,
  start_date,
  end_date,
  channel,
  discount_type,
  discount_value
from {{ ref('stg_campaigns') }}
