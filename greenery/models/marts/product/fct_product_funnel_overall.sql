with products_events as 
(
    SELECT * from {{ref('int_events_products')}}
),

total_sessions AS
(   SELECT 
        COUNT(DISTINCT session_id) as total_sessions
    from products_events
),

prep_table AS
(
SELECT 
    event_type,
    COUNT(DISTINCT session_id) as unique_sessions
from products_events 
WHERE event_type in ('page_view', 'add_to_cart', 'checkout')
GROUP BY 1
ORDER BY 1 DESC
),

pivoted_table AS
(
    SELECT 
        {{ dbt_utils.pivot(
           'event_type',
             ('page_view', 'add_to_cart', 'checkout'),
             agg='sum',
            then_value='unique_sessions'
         ) }}
    from prep_table
),

casted_table AS
(
SELECT 
    "page_view" AS page_view,
    "add_to_cart" AS add_to_cart,
    "checkout" AS checkout
from pivoted_table
)

SELECT 
(SELECT total_sessions from total_sessions) as total_sessions,
page_view,
add_to_cart, 
checkout,
ROUND(add_to_cart/(SELECT total_sessions from total_sessions), 2) as sessions_with_add_to_cart,
ROUND(checkout/(SELECT total_sessions from total_sessions), 2) as sessions_with_transaction
from casted_table 
