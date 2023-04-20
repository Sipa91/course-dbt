SELECT 
p.name,
p.price,
p.inventory,
SUM(oi.quantity) as orders_per_product
from staging_products p
LEFT JOIN staging_order_items oi
on p.product_id = oi.product_id
GROUP BY 1,2,3