with events as 
(
    SELECT * FROM {{ref('staging_events')}}
),

products as 
( 
    SELECT * FROM {{ref('staging_products')}}
),

order_items as 
(
    SELECT * FROM {{ref('staging_order_items')}}
),

prep_table as 
(
    SELECT 
        e.event_id,
        e.session_id,
        e.created_at,
        e.event_type,
        e.order_id,
        p.name as product_name,
        oi.product_id,
        pp.name as product_name_2
    from events e
        LEFT JOIN products p
            on e.product_id = p.product_id
        LEFT JOIN order_items oi
            ON e.order_id = oi.order_id
        LEFT JOIN products pp
            on oi.product_id = pp.product_id
)

SELECT 
event_id,
session_id, 
created_at::DATE as date,
event_type,
{{events_dummy_coding()}}
order_id, 
CASE WHEN
    product_name IS NOT NULL
    THEN product_name
    ELSE product_name_2
END as product_name
FROM prep_table
