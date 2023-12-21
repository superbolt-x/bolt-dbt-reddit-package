{%- set selected_fields = [
    "id",
    "name",
    "bid_strategy",
    "optimization_strategy_type",
    "bid_value",
    "effective_status",
    "goal_type",
    "goal_value",
    "account_id",
    "campaign_id"
] -%}
{%- set schema_name, table_name = 'reddit', 'ad_groups' -%}

WITH staging AS 
    (SELECT
    
        {% for field in selected_fields -%}
        {{ get_reddit_clean_field(table_name, field) }},
        {% endfor -%}

    FROM {{ source(schema_name, table_name) }}
    )

SELECT *,
    ad_group_id as unique_key
FROM staging 
