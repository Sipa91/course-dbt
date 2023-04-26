{% macro events_dummy_coding() %}

CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 end as page_view,
CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 end as add_to_cart,
CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 end as checkout,
CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 end as package_shipped

{% endmacro %}