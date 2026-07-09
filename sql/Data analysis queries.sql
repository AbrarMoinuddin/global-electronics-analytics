-- Overall business performance by year

select year(s.order_date) as year,
		count(distinct s.Order_Number) as total_orders,
        sum(s.Quantity) as total_units_sold,
        sum(s.Quantity * p.Unit_Price_USD) as total_revenue,
        sum(s.Quantity * p.Unit_Cost_USD) as total_cost,
        sum(s.Quantity * p.Unit_Price_USD)- sum(s.Quantity * p.Unit_Cost_USD) as total_profit
 from sales s
 join products p on p.productkey = s.productkey
 group by year
 order by year;
 
-- Revenue by product category

select  p.Category,
		count(distinct s.Order_Number) as total_orders,
        sum(s.Quantity * p.Unit_Price_USD) as total_revenue,
		sum(s.Quantity * p.Unit_Cost_USD) as total_cost,
        round(((sum(s.Quantity * p.Unit_Price_USD)- sum(s.Quantity * p.Unit_Cost_USD))/sum(s.Quantity * p.Unit_Price_USD))*100,2) as profit_margin_pct
		
from sales s 
join products p on s.productkey = p.productkey
group by p.category
order by total_revenue desc;

-- MOM Revenue growth

with monthly_revenue as (
select 
	date_format(s.order_date,'%Y-%m') as month,
    sum(s.Quantity * p.Unit_Price_USD) as revenue
from sales s
join products p on p.productkey = s.productkey
group by month
order by month)
select 
	month,
    revenue,
    lag(revenue) over(order by month) as prev_month_revenue,
    round(((revenue - lag(revenue) over(order by month))/lag(revenue) over(order by month))*100,2) as growth_pct
from monthly_revenue;

-- Top 10 best selling products

select
	p.Product_Name,
    p.Brand,
    p.Category,
    sum(s.quantity) as units_sold,
    sum(s.Quantity* p.Unit_Price_USD) as total_revenue,
    sum(s.Quantity* p.Unit_Price_USD) - sum(s.Quantity* p.Unit_Cost_USD) as total_profit
    
from products p 
join sales s on s.productkey = p.productkey
group by p.product_name,p.brand,p.category
order by total_revenue desc
limit 10 ;

-- customer analysis

SELECT
	c.country,
    c.state,
    c.gender,
    COUNT(DISTINCT(s.CustomerKey)) AS total_customers,
    COUNT(DISTINCT(s.Order_Number)) AS total_orders,
    SUM(s.Quantity*p.Unit_Price_USD) AS total_revenue,
    ROUND(AVG(s.Quantity*p.Unit_Price_USD),2) AS AVG_order_value
FROM customers c
JOIN sales s ON s.CustomerKey = c.CustomerKey
JOIN products p ON p.ProductKey = s.ProductKey
GROUP BY c.country,c.State,c.gender
ORDER BY total_revenue DESC;

-- Delivery time analysis

SELECT
    st.Country                                              AS Type,
    COUNT(*)                                                AS total_orders,
    ROUND(AVG(DATEDIFF(s.Delivery_Date, s.Order_Date)), 1)  AS avg_delivery_days,
    MIN(DATEDIFF(s.Delivery_Date, s.Order_Date))            AS min_delivery_days,
    MAX(DATEDIFF(s.Delivery_Date, s.Order_Date))            AS max_delivery_days
FROM sales s
JOIN stores st ON s.StoreKey = st.StoreKey
WHERE s.Delivery_Date IS NOT NULL
GROUP BY st.Country
ORDER BY avg_delivery_days DESC;

-- Store performance

SELECT
	st.Country,
    st.State,
    st.Square_Meters,
    COUNT(distinct s.Order_Number) AS total_orders,
    SUM(s.Quantity*p.Unit_Price_USD) AS total_revenue,
    CASE 
		WHEN SUM(s.Quantity*p.Unit_Price_USD)>=500000 THEN 'High Performer'
        WHEN SUM(s.Quantity*p.Unit_Price_USD)>=200000 THEN 'Mid Performer'
        ELSE 'Low Performer'
        END AS performance_tier
FROM stores st
JOIN sales s ON s.StoreKey = st.StoreKey
JOIN products p ON p.ProductKey = s.ProductKey
GROUP BY st.Country,st.State
ORDER BY total_revenue DESC;

-- Top customer per country

SELECT country,name,total_revenue FROM (

SELECT 
	c.country,
    c.Name,
    SUM(s.Quantity * p.Unit_Price_USD) as total_revenue,
    RANK() OVER(PARTITION BY country ORDER BY SUM(s.Quantity * p.Unit_Price_USD) DESC) as country_rank
FROM customers c
JOIN sales s on s.CustomerKey = c.CustomerKey
JOIN products p on p.ProductKey = s.ProductKey
GROUP BY c.Country,c.CustomerKey
ORDER BY c.country,total_revenue desc)
rnk
WHERE country_rank = 1
ORDER BY total_revenue DESC;

-- Profit margin by brand

SELECT 
	p.Brand,
    COUNT(DISTINCT s.Order_Number) as total_orders,
    SUM(s.Quantity*p.Unit_Price_USD) as total_revenue,
    SUM(s.Quantity*p.Unit_Cost_USD) as total_cost,
    round(((SUM(s.Quantity*p.Unit_Price_USD)-SUM(s.Quantity*p.Unit_Cost_USD))/SUM(s.Quantity*p.Unit_Price_USD))*100,2) as profit_margin_pct
FROM products p
JOIN sales s on s.ProductKey = p.ProductKey
GROUP BY p.Brand
ORDER BY profit_margin_pct desc;

-- Online vs Store sales

SELECT
    CASE
        WHEN s.StoreKey = 0 THEN 'Online'
        ELSE 'In-Store'
    END AS sales_channel,
    COUNT(DISTINCT s.Order_Number)                AS total_orders,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2)  AS total_revenue,
    ROUND(AVG(s.Quantity * p.Unit_Price_USD), 2)  AS avg_order_value
FROM sales s
JOIN products p ON s.ProductKey = p.ProductKey
GROUP BY sales_channel;

