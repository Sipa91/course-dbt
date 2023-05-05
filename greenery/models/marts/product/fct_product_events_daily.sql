with products_events as 
(
    SELECT * from {{ref('int_events_products')}}
)

SELECT 
date,
product_name,
SUM(page_view) as number_of_page_views,
SUM(add_to_cart) as number_of_added_to_cart,
SUM(checkout) as number_of_checkouts
from products_events
WHERE event_type in ('page_view', 'add_to_cart', 'checkout')
GROUP BY 1,2
ORDER BY 1 DESC, 2