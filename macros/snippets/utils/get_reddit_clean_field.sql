{%- macro get_reddit_clean_field(table_name, column_name) %}

    {%- if column_name == 'id' -%}
        {{column_name}}::varchar as {{table_name|trim('s')}}_{{column_name}} 

    {%- elif column_name in ("name","configured_status","effective_status","is_processing") -%}
        {{column_name}} as {{table_name|trim('s')}}_{{column_name}} 

    {%- else -%}
        {{column_name}} 
    {%- endif -%}
        

{% endmacro -%}
