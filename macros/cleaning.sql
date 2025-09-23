{% macro pct_to_decimal(col) -%}
(
  CASE
    WHEN {{ col }} IS NULL THEN NULL
    ELSE
      CASE
        WHEN regexp_replace({{ col }}::text, '[^0-9,.\-]', '', 'g') = '' THEN NULL
        ELSE (
          CASE
            WHEN (
              replace(regexp_replace({{ col }}::text, '[^0-9,.\-]', '', 'g'), ',', '.')::numeric
            ) > 1
            THEN (replace(regexp_replace({{ col }}::text, '[^0-9,.\-]', '', 'g'), ',', '.')::numeric / 100.0)
            ELSE (replace(regexp_replace({{ col }}::text, '[^0-9,.\-]', '', 'g'), ',', '.')::numeric)
          END
        )
      END
  END
)
{%- endmacro %}

{% macro money_to_numeric(col) -%}
NULLIF(replace(regexp_replace({{ col }}::text, '[^0-9,.\-]', '', 'g'), ',', '.')::text,'')::numeric
{%- endmacro %}

{% macro date_from_text(col) -%}
-- Robust untuk input bertipe text ATAU date
CASE
  WHEN {{ col }} IS NULL THEN NULL
  WHEN ({{ col }}::text) ~ '^\d{4}/\d{2}/\d{2}$' THEN to_date({{ col }}::text, 'YYYY/MM/DD')
  WHEN ({{ col }}::text) ~ '^\d{4}-\d{2}-\d{2}$' THEN to_date({{ col }}::text, 'YYYY-MM-DD')
  WHEN ({{ col }}::text) ~ '^\d{2}/\d{2}/\d{4}$' THEN to_date({{ col }}::text, 'DD/MM/YYYY')
  WHEN ({{ col }}::text) ~ '^\d{2}-\d{2}-\d{4}$' THEN to_date({{ col }}::text, 'DD-MM-YYYY')
  ELSE NULL
END
{%- endmacro %}

{% macro age_bounds(col, which='min') -%}
CASE
  WHEN {{ col }}::text ~ '^\d{1,3}\s*-\s*\d{1,3}$' THEN
    CASE WHEN '{{ which }}'='min'
      THEN split_part({{ col }}::text, '-', 1)::int
      ELSE split_part({{ col }}::text, '-', 2)::int
    END
  ELSE NULL
END
{%- endmacro %}

{% macro normalize_channel(col) -%}
case
  when lower(trim({{ col }})) in ('app mobile','app','mobile app') then 'App Mobile'
  when lower(trim({{ col }})) in ('website','web','website banner','banner','site') then 'Website'
  when lower(trim({{ col }})) = 'email' then 'Email'
  when lower(trim({{ col }})) in ('social media','social','ig','fb','tiktok') then 'Social Media'
  else 'Other'
end
{%- endmacro %}
