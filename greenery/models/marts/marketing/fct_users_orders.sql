WITH interims_users_orders as (
    SELECT 
 {{ dbt_utils.generate_surrogate_key
    (
        ['user_id', 'created_at']
    )
            }}  as user_key,
    first_name,
    last_name,
    email, 
    phone_number,
    address,
    state,
    country,
    created_at as order_created_at,
    order_cost,
    shipping_cost,
    order_total
FROM {{ref('int_users_orders')}}
    )

SELECT
    user_key,
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
from interims_users_orders
GROUP BY 1,2,3,4,5,6,7,8
ORDER BY 2