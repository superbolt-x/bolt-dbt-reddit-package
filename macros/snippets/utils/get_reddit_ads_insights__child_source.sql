{%- macro get_reddit_ads_insights__child_source(table_name) -%}


{%- set action_types = dbt_utils.get_column_values(source('reddit_raw','ad_conversions_report'),'event_name') -%}

SELECT 
    date,
    ad_id,
    {% for action_type in action_types -%}
    {%- set alias = conversion_alias_config(action_type) -%}
    {%- if alias|length %}
        {%- if alias in ("search","add_to_cart","view_content","page_visit","lead","add_to_wishlist","sign_up") %}
            COALESCE(SUM(CASE WHEN event_name = '{{action_type}}' THEN total_items ELSE 0 END), 0) as "{{alias}}"
        {%- else %}
            COALESCE(SUM(CASE WHEN event_name = '{{action_type}}' THEN total_items ELSE 0 END), 0) as "{{alias}}",
            COALESCE(SUM(CASE WHEN event_name = '{{action_type}}' THEN total_value ELSE 0 END), 0) as "{{alias}}_value"
        {%- endif -%}
    {%- else -%}
        {%- if action_type in ("search","add_to_cart","view_content","page_visit","lead","add_to_wishlist","sign_up") %}
            COALESCE(SUM(CASE WHEN event_name = '{{action_type}}' THEN total_items ELSE 0 END), 0) as "{{action_type}}"
        {%- else %}
            COALESCE(SUM(CASE WHEN event_name = '{{action_type}}' THEN total_items ELSE 0 END), 0) as "{{action_type}}",
            COALESCE(SUM(CASE WHEN event_name = '{{action_type}}' THEN total_value ELSE 0 END), 0) as "{{action_type}}_value"
        {%- endif -%}
    {%- endif -%}
    {%- if not loop.last %},{% endif -%}
    {% endfor %}

    FROM {{ source('reddit_raw','ad_conversions_report') }}

    GROUP BY 1,2

{%- endmacro %}
