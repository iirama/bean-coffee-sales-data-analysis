CREATE view  vw_product_performance_final AS
/*=================================================================================
PRODUCT PERFORMANCE REPORT
=================================================================================
Purpose:
    - Focuses exclusively on product metrics
    - Provides sales, quantity, customer counts by time period
    - Includes price segment analysis
=================================================================================*/
WITH 
product_base AS (
    SELECT
        Product,
        Unit_Price,
        Final_Sales,
        Quantity,
        Customer_ID,
        Date,
        YEAR(Date) AS order_year,
        MONTH(Date) AS order_month,
        DATEFROMPARTS(YEAR(Date), MONTH(Date), 1) AS year_month
    FROM DatasetForCoffeeSales2
),

product_metrics AS (
    SELECT
        Product,
        AVG(Unit_Price) AS avg_price,
        SUM(Final_Sales) AS total_sales,
        SUM(Quantity) AS total_quantity,
        COUNT(DISTINCT Customer_ID) AS total_customers,
        MIN(Date) AS first_sale_date,
        MAX(Date) AS last_sale_date,
        CASE 
            WHEN AVG(Unit_Price) < 30 THEN 'Budget'
            WHEN AVG(Unit_Price) BETWEEN 30 AND 40 THEN 'Mid-Range'
            WHEN AVG(Unit_Price) BETWEEN 40 AND 45 THEN 'Premium'
            ELSE 'Luxury'
        END AS price_segment
    FROM product_base
    GROUP BY Product
),

time_period_metrics AS (
    SELECT
        Product,
        year_month,
        order_year,
        order_month,
        SUM(Final_Sales) AS period_sales,
        SUM(Quantity) AS period_quantity,
        COUNT(DISTINCT Customer_ID) AS period_customers
    FROM product_base
    GROUP BY Product, year_month, order_year, order_month
),

growth_metrics AS (
    SELECT
        Product,
        year_month,
        order_year,
        order_month,
        period_sales,
        LAG(period_sales) OVER (PARTITION BY Product ORDER BY year_month) AS prev_period_sales,
        CASE 
            WHEN LAG(period_sales) OVER (PARTITION BY Product ORDER BY year_month) = 0 THEN NULL
            ELSE ROUND((period_sales - LAG(period_sales) OVER (PARTITION BY Product ORDER BY year_month)) / 
                 LAG(period_sales) OVER (PARTITION BY Product ORDER BY year_month) * 100, 2)
        END AS sales_growth_pct
    FROM time_period_metrics
)

SELECT
    pm.Product,
    pm.avg_price,
    pm.total_sales,
    pm.total_quantity,
    pm.total_customers,
    pm.price_segment,
    pm.first_sale_date,
    pm.last_sale_date,
    gm.year_month,
    gm.order_year,
    gm.order_month,
    gm.period_sales,
    gm.prev_period_sales,
    gm.sales_growth_pct,
    CASE 
        WHEN gm.sales_growth_pct > 10 THEN 'Rapid Growth'
        WHEN gm.sales_growth_pct > 0 THEN 'Growing'
        WHEN gm.sales_growth_pct = 0 THEN 'Stable'
        WHEN gm.sales_growth_pct < 0 THEN 'Declining'
        ELSE 'New'
    END AS growth_category,
    RANK() OVER (ORDER BY pm.total_sales DESC) AS sales_rank
FROM product_metrics pm
LEFT JOIN growth_metrics gm ON pm.Product = gm.Product;