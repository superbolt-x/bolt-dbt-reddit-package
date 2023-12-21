{%- macro conversion_alias_config(conversion_name) -%}

{%- set config = (
    
    {"original_name": 'lead', "alias": 'leads'}

    )-%}

{{ return (config | selectattr('original_name', 'equalto', conversion_name)| map(attribute='alias')|join(' ')) }}


{%- endmacro -%}
