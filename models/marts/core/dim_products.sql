-- marts/core/dim_products.sql
-- Grain: one row per product_id
select
  product_id,
  product_name,
  category,
  brand,
  color,
  size,
  catalog_price,
  cost_price,
  gender
from {{ ref('stg_products') }}
