with src as (
  select * from {{ ref('dataset_fashion_store_stock') }}
)
select
  country::text       as country,
  product_id::int     as product_id,
  stock_quantity::int as stock_quantity
from src