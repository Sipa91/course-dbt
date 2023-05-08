with products_events as 
(
    SELECT * from {{ref('int_events_products')}}
),

prep_table AS
(
SELECT 
product_name,
event_type,
COUNT(DISTINCT session_id) as unique_sessions
from products_events 
WHERE event_type in ('page_view', 'add_to_cart', 'checkout')
GROUP BY 1,2
ORDER BY 1 DESC, 2),


pivoted_table AS
(
SELECT 
    product_name,
  {{ dbt_utils.pivot(
      'event_type',
      ('page_view', 'add_to_cart', 'checkout'),
      agg='sum',
      then_value='unique_sessions'
  ) }}
from prep_table
group by 1),

casted_table AS
(
    SELECT 
product_name,
"page_view" AS page_view,
"add_to_cart" AS add_to_cart,
"checkout" AS checkout
from pivoted_table
),

ous as ( 
    SELECT
    DISTINCT product_name, 
    COUNT(DISTINCT session_id) OVER() as overall_unique_sessions
    from products_events
)

SELECT 
ct.product_name,
os.overall_unique_sessions,
ct.page_view,
ct.add_to_cart, 
ct.checkout,
ROUND(page_view/overall_unique_sessions, 2) as sessions_with_pageview,
ROUND(add_to_cart/page_view, 2) as sessions_with_add_to_cart,
ROUND(checkout/page_view, 2) as sessions_with_transaction
from casted_table ct 
LEFT JOIN ous os
on ct.product_name = os.product_name
ORDER BY 1





