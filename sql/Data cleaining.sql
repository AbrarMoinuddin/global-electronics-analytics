USE electronics_analytics;


-- Checking NULLS in sales table
SELECT
    SUM(CASE WHEN order_date IS NULL    THEN 1 ELSE 0 END) AS null_order_dates,
    SUM(CASE WHEN delivery_date IS NULL THEN 1 ELSE 0 END) AS null_delivery_dates,
    SUM(CASE WHEN quantity IS NULL      THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN customerkey IS NULL  THEN 1 ELSE 0 END) AS null_customers,
    SUM(CASE WHEN productkey IS NULL   THEN 1 ELSE 0 END) AS null_products
FROM sales;

-- Checking NULLS in customers
SELECT
    SUM(CASE WHEN name IS NULL     THEN 1 ELSE 0 END) AS null_names,
    SUM(CASE WHEN country IS NULL  THEN 1 ELSE 0 END) AS null_countries,
    SUM(CASE WHEN gender IS NULL   THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN birthday IS NULL THEN 1 ELSE 0 END) AS null_birthday
FROM customers;

-- Check NULLS in products
SELECT
    SUM(CASE WHEN unit_cost_usd IS NULL  THEN 1 ELSE 0 END) AS null_cost,
    SUM(CASE WHEN unit_price_usd IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN brand IS NULL      THEN 1 ELSE 0 END) AS null_brand
FROM products;

-- Check date range of sales
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order
FROM sales;

-- Check delivery date NULLS 
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN delivery_date IS NULL THEN 1 ELSE 0 END) AS no_delivery_date,
    SUM(CASE WHEN delivery_date IS NOT NULL THEN 1 ELSE 0 END) AS has_delivery_date
FROM sales;

-- Check for negative quantities or prices
SELECT COUNT(*) AS bad_quantity FROM sales WHERE quantity <= 0;
SELECT COUNT(*) AS bad_cost    FROM products WHERE unit_cost_usd <= 0 OR unit_price_usd <= 0;

-- Check top countries in customer base
SELECT country, COUNT(*) AS customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC;



-- cleaning data - Remove sales with invalid quantity
DELETE FROM sales WHERE quantity <= 0;

-- Verify final row counts
SELECT 'sales'          AS table_name, COUNT(*) AS data FROM sales
UNION ALL
SELECT 'customers',                    COUNT(*) FROM customers
UNION ALL
SELECT 'products',                     COUNT(*) FROM products
UNION ALL
SELECT 'stores',                       COUNT(*) FROM stores;