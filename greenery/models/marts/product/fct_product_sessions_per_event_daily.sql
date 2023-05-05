with products_events as 
(
    SELECT * from {{ref('int_events_products')}}
),

total_sessions AS
(
  SELECT 
  product_name, 
  COUNT(DISTINCT session_id) as total_sessions
  from products_events
  GROUP BY 1
  ),

prep_table AS
(SELECT 
pe.date,
ts.product_name,
ts.total_sessions,
pe.event_type,
COUNT(DISTINCT pe.session_id) as unique_sessions
from products_events pe 
LEFT JOIN total_sessions ts
on pe.product_name = ts.product_name
WHERE event_type in ('page_view', 'add_to_cart', 'checkout')
GROUP BY 1,2,3,4
ORDER BY 1 DESC, 2, 4)

SELECT 
date,
product_name,
total_sessions,

  {{ dbt_utils.pivot(
      'event_type',
      ('page_view', 'add_to_cart', 'checkout'),
      agg='sum',
      then_value='unique_sessions'
  ) }}
from prep_table
group by 1,2,3
