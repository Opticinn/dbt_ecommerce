with src as (
  select * from {{ ref('dataset_fashion_store_products') }}
)
select
  product_id::int                       as product_id,
  product_name::text                    as product_name,
  category::text                        as category,
  brand::text                           as brand,
  color::text                           as color,
  size::text                            as size,
  {{ money_to_numeric('catalog_price') }}::numeric(12,2) as catalog_price,
  {{ money_to_numeric('cost_price') }}::numeric(12,2)    as cost_price,
  gender::text                          as gender
from src