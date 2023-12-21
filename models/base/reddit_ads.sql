{%- set selected_fields = [
    "id",
    "name",
    "effective_status",
    "account_id",
    "ad_group_id",
    "campaign_id",
    "click_url"
] -%}
{%- set schema_name, table_name = 'reddit_raw', 'ads' -%}

WITH staging AS 
    (SELECT
    
        {% for field in selected_fields -%}
        {{ get_reddit_clean_field(table_name, field) }},
        {% endfor -%}

    FROM {{ source(schema_name, table_name) }}
    )

SELECT *,
    ad_id as unique_key
FROM staging 
