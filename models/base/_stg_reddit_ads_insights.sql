{{ config( 
        materialized='incremental',
        unique_key='unique_key',
        on_schema_change='append_new_columns'
) }}

{%- set schema_name, table_name = 'reddit_raw', 'ad_report' -%}

{%- set insights_fields = adapter.get_columns_in_relation(source(schema_name, table_name))
                    |map(attribute="name")
                    -%}  

with insights_source as (

    SELECT 
        {%- for field in insights_fields %}
        {{ get_reddit_clean_field(table_name, field) }}
        {%- if not loop.last %},{%- endif %}
        {%- endfor %}
    FROM {{ source(schema_name, table_name) }}

    ),

    actions_source as (

    {{ get_reddit_ads_insights__child_source('ad_conversions_report') }}

    )

SELECT 
    *,
    MAX(_fivetran_synced) over (PARTITION BY account_id) as last_updated,
    ad_id||'_'||date as unique_key

FROM insights_source 
LEFT JOIN actions_source USING(date, ad_id)

{% if is_incremental() -%}

  -- this filter will only be applied on an incremental run
where date >= (select max(date)-30 from {{ this }})

{% endif %}
