{%- set selected_fields = [
    "id",
    "business_id",
    "name",
    "currency",
    "_fivetran_synced"
] -%}
{%- set schema_name, table_name = 'reddit_raw', 'accounts' -%}

WITH staging AS 
    (SELECT
    
        {% for field in selected_fields -%}
        {{ get_reddit_clean_field(table_name, field) }},
        {% endfor -%}
        MAX(_fivetran_synced) OVER (PARTITION BY id) as last_updated_time

    FROM {{ source(schema_name, table_name) }}
    )

SELECT *,
    account_id as unique_key
FROM staging 
