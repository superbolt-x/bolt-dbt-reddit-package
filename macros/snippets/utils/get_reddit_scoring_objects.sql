{%- macro get_reddit_scoring_objects() -%}

    TRIM(SPLIT_PART(ad_group_name, '-', 2)) as audience,
    TRIM(SPLIT_PART(ad_name, '-', 1))||' - '||TRIM(SPLIT_PART(ad_name, '-', 2)) as format_visual,
    TRIM(SPLIT_PART(ad_name, '-', 2)) as visual, 
    TRIM(SPLIT_PART(ad_name, '-', 3)) as copy,
    TRIM(SPLIT_PART(ad_name, '-', 2))||' - '||TRIM(SPLIT_PART(ad_name, '-', 3)) as visual_copy

{%- endmacro -%}
