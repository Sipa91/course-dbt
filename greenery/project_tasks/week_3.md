# What is our overall conversion rate?
        SELECT 
                COUNT(DISTINCT session_id) as unique_sessions,
                SUM(checkout) as purchase_sessions,
                ROUND(SUM(checkout)/(COUNT(DISTINCT session_id)),2) as CR
        from int_events_products

0.62

# What is our conversion rate by product?
        WITH sessions_per_product as 
                 ( 
                SELECT 
                product_name,
                COUNT(DISTINCT session_id) as unique_sessions
                from int_events_products
                GROUP BY 1
                ),

        purchased_products as 
                (
                SELECT 
                p.name as product_name,
                COUNT(DISTINCT iep.session_id) as checkouts_per_product
                from int_events_products iep
                LEFT JOIN staging_order_items oi
                ON iep.order_id = oi.order_id
                LEFT JOIN staging_products p
                on oi.product_id = p.product_id
                where event_type = 'checkout'
                GROUP BY 1
                )

        SELECT 
                pp.product_name,
                pp.checkouts_per_product,
                spp.unique_sessions,
                ROUND(pp.checkouts_per_product/spp.unique_sessions,2) as CR
        from purchased_products pp
                LEFT JOIN sessions_per_product spp
                on pp.product_name = spp.product_name;
    
# Lineage Graph
![CR_per_product](pictures/CR_per_product.png)
