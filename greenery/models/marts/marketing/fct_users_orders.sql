SELECT 
last_name, 
first_name, 
email,
phone_number,
address,
state,
country,
COUNT(order_created_at) as number_of_orders,
SUM(order_cost) as order_spend,
SUM(shipping_cost) as shipping_spend, 
SUM(order_total) as total_order_spend
from {{ref('int_users_orders')}}
GROUP BY 1,2,3,4,5,6,7
ORDER BY 1