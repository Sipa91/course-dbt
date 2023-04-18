## How many users do we have?

                SELECT COUNT(DISTINCT user_id)
                from staging_users
130
## On average, how many orders do we receive per hour?

                SELECT 
                COUNT(DISTINCT order_id)/(DATEDIFF(second, min(created_at), max(created_at))/3600)
                from staging_orders


7.53
## On average, how long does an order take from being placed to being delivered?

                SELECT SUM(DATEDIFF(day, created_at, delivered_at))/COUNT(DISTINCT order_id)
                from staging_orders
                WHERE DELIVERED_AT IS NOT NULL
3.89
## How many users have only made one purchase? Two purchases? Three+ purchases?

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

                SELECT COUNT(user_id) from (
    SELECT DISTINCT user_id, COUNT(order_id)
    from staging_orders
    GROUP BY user_id
    HAVING COUNT(order_id)=1) 

25
## On average, how many unique sessions do we have per hour?
                WITH prep as (
                    SELECT 
                    EXTRACT(hour from created_at) as hour, 
                    count(DISTINCT session_id) as sessions
                from staging_events
                GROUP BY 1)

                SELECT AVG(sessions)
                from prep