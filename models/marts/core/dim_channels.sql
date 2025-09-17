-- marts/core/dim_channels.sql
-- Grain: one row per channel
select
  channel,
  description
from {{ ref('stg_channels') }}
