# tools/scaffold_marts.py
import os
import sys
from pathlib import Path
from textwrap import dedent

ROOT = Path(__file__).resolve().parents[1]  # project root (folder dbt)
MARTS_CORE = ROOT / "models" / "marts" / "core"
MARTS_SHARED = ROOT / "models" / "marts" / "shared"
MARTS_YML = ROOT / "models" / "marts" / "marts.yml"

OVERWRITE = os.getenv("OVERWRITE") == "1"
INCLUDE_DIM_DATE = "--no-date" not in sys.argv  # default: True

def write_file(path: Path, content: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not OVERWRITE:
        print(f"SKIP (exists): {path}")
        return
    path.write_text(dedent(content).strip() + "\n", encoding="utf-8")
    print(f"WROTE: {path}")

DIM_CUSTOMERS = """
-- marts/core/dim_customers.sql
-- Grain: one row per customer_id
select
  customer_id,
  country,
  age_min,
  age_max,
  signup_date
from {{ ref('stg_customers') }}
"""

DIM_PRODUCTS = """
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
"""

DIM_CHANNELS = """
-- marts/core/dim_channels.sql
-- Grain: one row per channel
select
  channel,
  description
from {{ ref('stg_channels') }}
"""

DIM_CAMPAIGNS = """
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
"""

FACT_SALES_ITEMS = """
-- marts/core/fact_sales_items.sql
-- Grain: one row per item_id (item dalam transaksi)
{{ config(
    materialized='table',
    post_hook=[
      "create index if not exists idx_fact_sales_items_sale_date on {{ this }} (sale_date)",
      "create index if not exists idx_fact_sales_items_product on {{ this }} (product_id)",
      "create index if not exists idx_fact_sales_items_customer on {{ this }} (customer_id)"
    ]
) }}

with si as (
  select * from {{ ref('stg_salesitems') }}
),
s as (
  select * from {{ ref('stg_sales') }}
)
select
  si.item_id,
  si.sale_id,
  s.sale_date,
  s.country,
  si.product_id,
  s.customer_id,
  si.channel,
  si.quantity,
  si.original_price,
  si.unit_price,
  si.discount_applied,
  si.discount_pct,
  si.is_discounted,
  si.item_total,
  -- Metrics turunan
  (si.unit_price * si.quantity)::numeric(12,2)                         as gross_revenue,
  (si.original_price - si.unit_price)::numeric(12,2)                   as unit_discount,
  ((si.original_price - si.unit_price) * si.quantity)::numeric(12,2)   as total_discount
from si
left join s using (sale_id, channel, sale_date)
"""

DIM_DATE = """
-- models/marts/shared/dim_date.sql
-- Simple calendar dimension (daily). Sesuaikan start_end jika perlu.
{{ config(materialized='table') }}

with bounds as (
  select
    coalesce(min(sale_date), date '2020-01-01') as start_date,
    coalesce(max(sale_date), date '2025-12-31') as end_date
  from {{ ref('stg_sales') }}
),
dates as (
  select generate_series(
    (select start_date from bounds),
    (select end_date   from bounds),
    interval '1 day'
  )::date as date_day
)
select
  date_day                               as date_key,
  extract(year  from date_day)::int      as year,
  extract(quarter from date_day)::int    as quarter,
  extract(month from date_day)::int      as month,
  to_char(date_day, 'Mon')               as month_name,
  extract(day   from date_day)::int      as day,
  extract(isodow from date_day)::int     as iso_dow,
  to_char(date_day, 'Dy')                as day_name,
  case when extract(isodow from date_day) in (6,7) then true else false end as is_weekend,
  to_char(date_day, 'IYYY-IW')           as iso_week
from dates
order by date_key
"""

MARTS_YAML = """
version: 2

models:
  - name: dim_customers
    description: "Dimensi pelanggan"
    tests:
      - unique:
          column_name: customer_id
      - not_null:
          column_name: customer_id

  - name: dim_products
    description: "Dimensi produk"
    tests:
      - unique:
          column_name: product_id
      - not_null:
          column_name: product_id

  - name: dim_channels
    description: "Dimensi channel penjualan"
    tests:
      - unique:
          column_name: channel
      - not_null:
          column_name: channel

  - name: dim_campaigns
    description: "Dimensi kampanye pemasaran"
    tests:
      - unique:
          column_name: campaign_id
      - not_null:
          column_name: campaign_id

  - name: fact_sales_items
    description: "Fakta item penjualan (grain: item_id)"
    tests:
      - not_null:
          column_name: item_id
      - unique:
          column_name: item_id
      - relationships:
          to: ref('dim_products')
          column: product_id
      - relationships:
          to: ref('dim_customers')
          column: customer_id
"""

def main():
    # core dims & fact
    write_file(MARTS_CORE / "dim_customers.sql", DIM_CUSTOMERS)
    write_file(MARTS_CORE / "dim_products.sql", DIM_PRODUCTS)
    write_file(MARTS_CORE / "dim_channels.sql", DIM_CHANNELS)
    write_file(MARTS_CORE / "dim_campaigns.sql", DIM_CAMPAIGNS)
    write_file(MARTS_CORE / "fact_sales_items.sql", FACT_SALES_ITEMS)

    # shared (dim_date) optional
    if INCLUDE_DIM_DATE:
        write_file(MARTS_SHARED / "dim_date.sql", DIM_DATE)

    # marts.yml tests/docs
    write_file(MARTS_YML, MARTS_YAML)

if __name__ == "__main__":
    main()
