{{ config (
    alias = target.database + '_reddit_performance_by_campaign'

)}}

{%- set date_granularity_list = ['day','week','month','quarter','year'] -%}
{%- set exclude_fields = ['last_updated','date','day','week','month','quarter','year','unique_key'] -%}
{%- set dimensions = ['account_id','campaign_id'] -%}
{%- set measures = adapter.get_columns_in_relation(ref('reddit_campaigns_insights'))
                    |map(attribute="name")
                    |reject("in",exclude_fields)
                    |reject("in",dimensions)
                    |list
                    -%}  

WITH 
    {%- for date_granularity in date_granularity_list %}

    performance_{{date_granularity}} AS 
    (SELECT 
        '{{date_granularity}}' as date_granularity,
        {{date_granularity}} as date,
        {%- for dimension in dimensions %}
        {{ dimension }},
        {%-  endfor %}
        {% for measure in measures -%}
        COALESCE(SUM("{{ measure }}"),0) as "{{ measure }}"
        {%- if not loop.last %},{%- endif %}
        {% endfor %}
    FROM {{ ref('reddit_campaigns_insights') }}
    GROUP BY {{ range(1, dimensions|length +2 +1)|list|join(',') }}),
    {%- endfor %}

    campaigns AS 
    (SELECT account_id, campaign_id::varchar as campaign_id, campaign_name, campaign_effective_status
    FROM {{ ref('reddit_campaigns') }}
    ),

    accounts AS 
    (SELECT account_id, account_name, currency
    FROM {{ ref('reddit_accounts') }} 
    )

SELECT *,
    {{ get_reddit_default_campaign_types('campaign_name')}}
FROM 
    ({% for date_granularity in date_granularity_list -%}
    SELECT *
    FROM performance_{{date_granularity}}
    {% if not loop.last %}UNION ALL
    {% endif %}

    {%- endfor %}
    )
LEFT JOIN campaigns USING(account_id, campaign_id)
