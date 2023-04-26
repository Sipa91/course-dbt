# What is our overall conversion rate?
        with all_sessions as (
        SELECT COUNT(DISTINCT session_id) as unique_sessions
        from int_events_products),

        purchase_sessions as (
        SELECT COUNT(DISTINCT session_id) as purchase_sessions
        from int_events_products
        WHERE order_id IS NOT NULL)

        SELECT ROUND(purchase_sessions/(SELECT unique_sessions from all_sessions),2)
        from purchase_sessions

0.62

# What is our conversion rate by product?
