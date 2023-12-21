{{ config( 
        materialized='incremental',
        unique_key='unique_key',
        on_schema_change='append_new_columns'
) }}

{%- set schema_name, table_name = 'reddit_raw', 'ad_report' -%}

with insights_source as (

    SELECT * 
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
where date >= (select max(date)-7 from {{ this }})

{% endif %}
