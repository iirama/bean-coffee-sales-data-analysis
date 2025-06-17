/*===========================================================================================
-------------------------------- Sales Performance Report -----------------------------------
=============================================================================================

Purpose:
    - This report evaluates sales performance across cities, identifying high-value markets,
      customer behavior, and revenue trends to support strategic decision-making.

Highlights:
    1. City Segmentation:
        - Categorizes cities into demand tiers (Very-High, High, Regular, Low) based on:
            • Revenue contribution
            • Order volume
        - Identifies growth opportunities and underperforming markets

    2. Key Aggregations:
        - Total Orders: Sum of all transactions
        - Total Customers: Unique Customer_ID counts per city
        - City Coverage: Number of distinct cities in dataset
        - Sales Distribution: Percentage of total sales by city tier

    3. Performance KPIs:
        - Average Order Revenue (AOR) = Total Final_Sales / Total Orders
        - Average Monthly Sales = Total Final_Sales / Number of Months
        - Discount Effectiveness = (SUM(Final_Sales where Used_Discount=1) - SUM(Discount_Amount)) / COUNT(Orders)
        - Product Penetration Rate = COUNT(DISTINCT Customer_ID per Product) / Total Customers

    4. Behavioral Metrics:
        - Discount Utilization Rate = COUNT(Used_Discount=1) / Total Orders
        - Premium Product Ratio = SUM(Sales_Amount where Unit_Price > [threshold]) / Total Sales
        - Customer Concentration = (Customers in Top 3 Cities) / Total Customers

=============================================================================================*/


WITH city_stats AS (
    SELECT 
        City,
        COUNT(DISTINCT Customer_ID) AS total_customers,
        COUNT(*) AS total_orders,
        SUM(Quantity) AS total_quantity,
        SUM(Final_Sales) AS total_revenue,
        SUM(CASE WHEN Used_Discount = 1 THEN 1 ELSE 0 END) AS discounted_orders,
        SUM(Discount_Amount) AS total_discounts,
        AVG(Unit_Price * CAST(Quantity AS DECIMAL(10,2))) AS avg_order_value,
        AVG(CAST(Quantity AS DECIMAL(10,2))) AS avg_quantity_per_order
    FROM DatasetForCoffeeSales2
    GROUP BY City
),

city_tiers AS (
    SELECT 
        City,
        total_customers,
        total_orders,
        total_quantity,
        total_revenue,
        discounted_orders,
        total_discounts,
        avg_order_value,
        avg_quantity_per_order,
        NTILE(4) OVER (ORDER BY total_revenue DESC) AS revenue_tier,
        NTILE(4) OVER (ORDER BY total_orders DESC) AS volume_tier,
        CASE 
            WHEN total_revenue >= PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_revenue) OVER () 
                 THEN 'Very-High'
            WHEN total_revenue >= PERCENTILE_CONT(0.7) WITHIN GROUP (ORDER BY total_revenue) OVER ()
                 THEN 'High'
            WHEN total_revenue >= PERCENTILE_CONT(0.4) WITHIN GROUP (ORDER BY total_revenue) OVER ()
                 THEN 'Regular'
            ELSE 'Low'
        END AS demand_segment
    FROM city_stats
),

product_stats AS (
    SELECT
        City,
        Product,
        COUNT(DISTINCT Customer_ID) AS product_customers,
        SUM(Quantity) AS total_units_sold,
        SUM(Final_Sales) AS product_revenue,
        RANK() OVER (PARTITION BY City ORDER BY SUM(Final_Sales) DESC) AS product_rank
    FROM DatasetForCoffeeSales2
    GROUP BY City, Product
)

-- FINAL REPORT OUTPUT
SELECT 
    -- City Identification
    ct.City,
    ct.demand_segment,
    
    -- Customer Metrics
    ct.total_customers,
    ROUND(ct.total_customers * 100.0 / NULLIF(SUM(ct.total_customers) OVER (), 0), 2) AS customer_share_pct,
    
    -- Order Metrics
    ct.total_orders,
    ct.total_quantity,
    ROUND(ct.avg_quantity_per_order, 2) AS avg_items_per_order,
    ROUND(ct.total_orders * 100.0 / NULLIF(SUM(ct.total_orders) OVER (), 0), 2) AS order_share_pct,
    
    -- Financial Metrics
    ct.total_revenue,
    ROUND(ct.total_revenue * 100.0 / NULLIF(SUM(ct.total_revenue) OVER (), 0), 2) AS revenue_share_pct,
    ROUND(ct.avg_order_value, 2) AS avg_order_value,
    
    -- Discount Analysis
    ROUND(ct.discounted_orders * 100.0 / NULLIF(ct.total_orders, 0), 2) AS discount_utilization_pct,
    ROUND(ct.total_discounts * 100.0 / NULLIF(ct.total_revenue, 0), 2) AS discount_to_sales_ratio,
    
    -- Tier Classification
    ct.revenue_tier,
    ct.volume_tier,
    
    -- Top Product Info
    (SELECT TOP 1 Product FROM product_stats ps 
     WHERE ps.City = ct.City ORDER BY ps.product_rank) AS top_product,
    (SELECT TOP 1 ROUND(product_revenue, 2) FROM product_stats ps 
     WHERE ps.City = ct.City ORDER BY ps.product_rank) AS top_product_revenue
    
FROM city_tiers ct
ORDER BY 
    CASE ct.demand_segment
        WHEN 'Very-High' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Regular' THEN 3
        ELSE 4
    END,
    ct.total_revenue DESC;

