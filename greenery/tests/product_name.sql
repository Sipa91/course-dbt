--all product should have prices greater than 0
SELECT *
from {{ ref('dim_products') }}
WHERE price <= 0