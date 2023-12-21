{%- macro conversion_alias_config(conversion_name) -%}

{%- set config = (
    
    {"original_name": 'lead', "alias": 'leads'},
    {"original_name": 'purchase', "alias": 'purchases'}

    )-%}

{{ return (config | selectattr('original_name', 'equalto', conversion_name)| map(attribute='alias')|join(' ')) }}


{%- endmacro -%}
