SELECT u.*,
a.address,
a.state,
a.country,
o.created_at as order_created_at,
o.order_cost,
o.shipping_cost,
o.order_total
FROM {{ref('staging_users')}} u
LEFT JOIN {{ref('staging_addresses')}} a
on u.address_id = a.address_id
LEFT JOIN {{ref('staging_orders')}} o
on u.user_id = o.user_id