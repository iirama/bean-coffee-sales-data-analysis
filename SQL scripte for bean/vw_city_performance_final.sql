CREATE view vw_city_performance_final AS
/*=================================================================================
CITY PERFORMANCE REPORT
=================================================================================
Purpose:
    - Focuses exclusively on geographic metrics
    - Provides sales, customers, and product distribution by city
    - Includes time-based analysis
=================================================================================*/
WITH 
city_base AS (
    SELECT
        City,
        Final_Sales,
        Quantity,
        Customer_ID,
        Product,
        Date,
        YEAR(Date) AS order_year,
        MONTH(Date) AS order_month,
        DATEFROMPARTS(YEAR(Date), MONTH(Date), 1) AS year_month
    FROM DatasetForCoffeeSales2
),

city_metrics AS (
    SELECT
        City,
        SUM(Final_Sales) AS total_sales,
        SUM(Quantity) AS total_quantity,
        COUNT(DISTINCT Customer_ID) AS total_customers,
        COUNT(DISTINCT Product) AS unique_products,
        MIN(Date) AS first_sale_date,
        MAX(Date) AS last_sale_date,
        DATEDIFF(MONTH, MIN(Date), MAX(Date)) AS sales_timespan_months,
        CASE
            WHEN COUNT(DISTINCT Customer_ID) > 1000 THEN 'Large Market'
            WHEN COUNT(DISTINCT Customer_ID) > 500 THEN 'Medium Market'
            ELSE 'Small Market'
        END AS market_size
    FROM city_base
    GROUP BY City
),

time_period_metrics AS (
    SELECT
        City,
        year_month,
        order_year,
        order_month,
        SUM(Final_Sales) AS period_sales,
        SUM(Quantity) AS period_quantity,
        COUNT(DISTINCT Customer_ID) AS period_customers
    FROM city_base
    GROUP BY City, year_month, order_year, order_month
),

growth_metrics AS (
    SELECT
        City,
        year_month,
        order_year,
        order_month,
        period_sales,
        LAG(period_sales) OVER (PARTITION BY City ORDER BY year_month) AS prev_period_sales,
        CASE 
            WHEN LAG(period_sales) OVER (PARTITION BY City ORDER BY year_month) = 0 THEN NULL
            ELSE ROUND((period_sales - LAG(period_sales) OVER (PARTITION BY City ORDER BY year_month)) / 
                 LAG(period_sales) OVER (PARTITION BY City ORDER BY year_month) * 100, 2)
        END AS sales_growth_pct
    FROM time_period_metrics
),

top_products AS (
    SELECT
        City,
        Product AS top_product,
        SUM(Final_Sales) AS top_product_sales,
        ROW_NUMBER() OVER (PARTITION BY City ORDER BY SUM(Final_Sales) DESC) AS rank
    FROM city_base
    GROUP BY City, Product
)

SELECT
    cm.City,
    cm.total_sales,
    cm.total_quantity,
    cm.total_customers,
    cm.unique_products,
    cm.market_size,
    cm.first_sale_date,
    cm.last_sale_date,
    cm.sales_timespan_months,
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
    tp.top_product,
    tp.top_product_sales,
    RANK() OVER (ORDER BY cm.total_sales DESC) AS sales_rank
FROM city_metrics cm
LEFT JOIN growth_metrics gm ON cm.City = gm.City
LEFT JOIN top_products tp ON cm.City = tp.City AND tp.rank = 1;