SELECT e.*, p.name 
from {{ref('staging_events')}} e
LEFT JOIN staging_products p
on e.product_id = p.product_id
WHERE event_type = 'page_view'