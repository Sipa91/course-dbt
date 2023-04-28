with products_events as 
(
    SELECT * from {{ref('int_events_products')}}
)

SELECT 
created_at::DATE as date,
product_name,
SUM(page_view) as number_of_page_views,
SUM(add_to_cart) as number_of_added_to_cart
from products_events
WHERE product_name IS NOT NULL
GROUP BY 1,2