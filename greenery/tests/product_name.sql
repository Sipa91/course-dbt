--all product should have a name and a price
SELECT *
from {{ ref('dim_products') }}
WHERE name IS NULL or price IS NULL