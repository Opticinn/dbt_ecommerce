with si as (
  select * from {{ ref('stg_salesitems') }}
),
s as (
  select * from {{ ref('stg_sales') }}
)
select
  si.item_id,
  si.sale_id,
  -- pilih salah satu baris di bawah (aktifkan SATU saja):
  coalesce(s.sale_date, si.sale_date, '1900-01-01'::date) as sale_date,
  -- coalesce(s.sale_date, si.sale_date) as sale_date,

  s.country as country,
  si.product_id,
  coalesce(s.customer_id, -1) as customer_id,
  si.channel,
  si.quantity,
  si.original_price,
  si.unit_price,
  si.discount_applied,
  si.discount_pct,
  si.is_discounted,
  si.item_total,
  (si.unit_price * si.quantity)::numeric(12,2)                        as gross_revenue,
  (si.original_price - si.unit_price)::numeric(12,2)                  as unit_discount,
  ((si.original_price - si.unit_price) * si.quantity)::numeric(12,2)  as total_discount
from si
left join s using (sale_id)