{%- set selected_fields = [
    "id",
    "name",
    "effective_status",
    "account_id",
    "objective"
] -%}
{%- set schema_name, table_name = 'reddit_raw', 'campaigns' -%}

WITH staging AS 
    (SELECT
    
        {% for field in selected_fields -%}
        {{ get_reddit_clean_field(table_name, field) }}
        {%- if not loop.last %},{% endif -%}
        {% endfor -%}

    FROM {{ source(schema_name, table_name) }}
    )

SELECT *,
    campaign_id as unique_key
FROM staging 
