with events as 
(
    SELECT * FROM {{ref('staging_events')}}
),

products as 
( 
    SELECT * FROM {{ref('staging_products')}}
)

SELECT 
e.event_id,
e.session_id,
e.created_at,
e.event_type,
{{events_dummy_coding()}},
e.order_id,
p.name as product_name
from events e
LEFT JOIN products p
on e.product_id = p.product_id