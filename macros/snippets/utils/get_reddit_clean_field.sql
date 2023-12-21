{%- macro get_reddit_clean_field(table_name, column_name) %}
    {%- set reject_fields = [
    "id",
    "business_id",
    "name",
    "currency",
    "_fivetran_synced"
    ] -%}

    {%- if column_name == 'id' -%}
        {{column_name}}::varchar as {{table_name|trim('s')}}_{{column_name}}

    {%- elif column_name in ("name","configured_status","effective_status","is_processing","account_id","ad_group_id","campaign_id","business_id") -%}
        {{column_name}} as {{table_name|trim('s')}}_{{column_name}}

    {%- else -%}
        {{column_name}}
    {%- endif -%}
        

{% endmacro -%}
