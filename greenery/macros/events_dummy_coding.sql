{% macro events_dummy_coding() %}

{% set event_type_vals = dbt_utils.get_column_values(table=ref('staging_events') , column='event_type') %}

{% for event_type in event_type_vals  %}
CASE WHEN event_type = '{{ event_type }}' THEN 1 ELSE 0 END AS {{ event_type }},
{% endfor %}

{% endmacro %}