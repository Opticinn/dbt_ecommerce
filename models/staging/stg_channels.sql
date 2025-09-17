select
  channel::text      as channel,
  description::text  as description
from {{ ref('dataset_fashion_store_channels') }}