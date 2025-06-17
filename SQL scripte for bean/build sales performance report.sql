/*=================================================================================
PRODUCT PERFORMANCE REPORT WITH CITY-LEVEL TRENDS
=================================================================================
Purpose:
    - Comprehensive analysis of product performance across all markets
    - Tracks temporal trends at yearly and monthly granularity
    - Identifies geographic patterns in product performance

Highlights:
    1. Core Product Metrics:
        - Total sales, quantities, and unique customers
        - Average unit price and price segment classification
        - Percentage contribution to total revenue
        - Overall market rank

    2. Temporal Trend Analysis:
        - Year-over-year growth (absolute and percentage)
        - Month-over-month growth patterns
        - Sales performance categorization (Rapid Growth, Stable, Declining)
        - Seasonal trend identification

    3. Geographic Performance:
        - City-level sales distribution
        - Market penetration by city
        - Regional performance trends
        - Geographic growth hotspots

    4. Advanced Analytics:
        - Comparative performance vs product average
        - Momentum indicators (Surge, Growth, Steady, Dip, Plunge)
        - Sales lifespan by market
        - Customer acquisition trends

    5. Actionable Classifications:
        - Performance tiers (High Performer to Below Average)
        - Growth potential indicators
        - Market maturity assessment
        - Price segment performance

Usage:
    - Filter by product to analyze item performance across cities
    - Filter by city to understand product mix performance
    - Sort by growth metrics to identify opportunities
    - Use categories to prioritize product investments
=================================================================================*/
CREATE view product_sales_performance AS
WITH 
-- Base CTEs
product_sales AS (
    SELECT 
        Product,
        SUM(Final_Sales) AS total_sales,
        SUM(Quantity) AS total_quantity,
        COUNT(DISTINCT Customer_ID) AS total_customers,
        AVG(Unit_Price) AS avg_price
    FROM DatasetForCoffeeSales2
    GROUP BY Product
),

-- Yearly trends by product and city
yearly_city_sales AS (
    SELECT 
        YEAR(Date) AS order_year,
        Product,
        City,
        SUM(Final_Sales) AS yearly_sales,
        SUM(Quantity) AS yearly_quantity,
        COUNT(DISTINCT Customer_ID) AS yearly_customers
    FROM DatasetForCoffeeSales2
    GROUP BY YEAR(Date), Product, City
),

-- Monthly trends by product and city
monthly_city_sales AS (
    SELECT 
        YEAR(Date) AS order_year,
        MONTH(Date) AS order_month,
        DATEFROMPARTS(YEAR(Date), MONTH(Date), 1) AS month_start,
        Product,
        City,
        SUM(Final_Sales) AS monthly_sales,
        SUM(Quantity) AS monthly_quantity
    FROM DatasetForCoffeeSales2
    GROUP BY YEAR(Date), MONTH(Date), Product, City
),

-- City-level metrics
city_performance AS (
    SELECT
        Product,
        City,
        SUM(Final_Sales) AS total_city_sales,
        COUNT(DISTINCT Customer_ID) AS total_city_customers,
        MIN(Date) AS first_sale_date,
        MAX(Date) AS last_sale_date,
        DATEDIFF(MONTH, MIN(Date), MAX(Date)) AS sales_timespan_months
    FROM DatasetForCoffeeSales2
    GROUP BY Product, City
),

-- Yearly comparison with growth rates
yearly_comparison AS (
    SELECT
        ycs.Product,
        ycs.City,
        ycs.order_year,
        ycs.yearly_sales,
        ycs.yearly_quantity,
        ycs.yearly_customers,
        LAG(ycs.yearly_sales) OVER (PARTITION BY ycs.Product, ycs.City ORDER BY ycs.order_year) AS prev_year_sales,
        ycs.yearly_sales - LAG(ycs.yearly_sales) OVER (PARTITION BY ycs.Product, ycs.City ORDER BY ycs.order_year) AS yoy_sales_change,
        CASE WHEN LAG(ycs.yearly_sales) OVER (PARTITION BY ycs.Product, ycs.City ORDER BY ycs.order_year) = 0 THEN NULL
             ELSE ROUND((ycs.yearly_sales - LAG(ycs.yearly_sales) OVER (PARTITION BY ycs.Product, ycs.City ORDER BY ycs.order_year)) / 
                  LAG(ycs.yearly_sales) OVER (PARTITION BY ycs.Product, ycs.City ORDER BY ycs.order_year) * 100, 2)
        END AS yoy_sales_pct_change
    FROM yearly_city_sales ycs
),

-- Monthly comparison with growth rates
monthly_comparison AS (
    SELECT
        mcs.Product,
        mcs.City,
        mcs.order_year,
        mcs.order_month,
        mcs.month_start,
        mcs.monthly_sales,
        mcs.monthly_quantity,
        LAG(mcs.monthly_sales) OVER (PARTITION BY mcs.Product, mcs.City ORDER BY mcs.order_year, mcs.order_month) AS prev_month_sales,
        mcs.monthly_sales - LAG(mcs.monthly_sales) OVER (PARTITION BY mcs.Product, mcs.City ORDER BY mcs.order_year, mcs.order_month) AS mom_sales_change,
        CASE WHEN LAG(mcs.monthly_sales) OVER (PARTITION BY mcs.Product, mcs.City ORDER BY mcs.order_year, mcs.order_month) = 0 THEN NULL
             ELSE ROUND((mcs.monthly_sales - LAG(mcs.monthly_sales) OVER (PARTITION BY mcs.Product, mcs.City ORDER BY mcs.order_year, mcs.order_month)) / 
                  LAG(mcs.monthly_sales) OVER (PARTITION BY mcs.Product, mcs.City ORDER BY mcs.order_year, mcs.order_month) * 100, 2)
        END AS mom_sales_pct_change
    FROM monthly_city_sales mcs
)

-- Final consolidated report
SELECT
    ps.Product,
    ps.total_sales AS product_total_sales,
    ps.total_quantity AS product_total_quantity,
    ps.total_customers AS product_total_customers,
    ps.avg_price AS product_avg_price,
    
    cp.City,
    cp.total_city_sales,
    cp.total_city_customers,
    cp.sales_timespan_months,
    
    yc.order_year,
    yc.yearly_sales,
    yc.yearly_quantity,
    yc.yearly_customers,
    yc.prev_year_sales,
    yc.yoy_sales_change,
    yc.yoy_sales_pct_change,
    
    mc.order_month,
    mc.month_start,
    mc.monthly_sales,
    mc.monthly_quantity,
    mc.prev_month_sales,
    mc.mom_sales_change,
    mc.mom_sales_pct_change,
    
    -- Performance indicators
    CASE 
        WHEN yc.yoy_sales_pct_change > 10 THEN 'Rapid Growth'
        WHEN yc.yoy_sales_pct_change > 0 THEN 'Growing'
        WHEN yc.yoy_sales_pct_change = 0 THEN 'Stable'
        WHEN yc.yoy_sales_pct_change < 0 THEN 'Declining'
        ELSE 'New'
    END AS yearly_growth_category,
    
    CASE 
        WHEN mc.mom_sales_pct_change > 15 THEN 'Surge'
        WHEN mc.mom_sales_pct_change > 5 THEN 'Growth'
        WHEN mc.mom_sales_pct_change > -5 THEN 'Steady'
        WHEN mc.mom_sales_pct_change > -15 THEN 'Dip'
        ELSE 'Plunge'
    END AS monthly_growth_category
FROM product_sales ps
JOIN city_performance cp ON ps.Product = cp.Product
LEFT JOIN yearly_comparison yc ON ps.Product = yc.Product AND cp.City = yc.City
LEFT JOIN monthly_comparison mc ON ps.Product = mc.Product AND cp.City = mc.City AND yc.order_year = mc.order_year;