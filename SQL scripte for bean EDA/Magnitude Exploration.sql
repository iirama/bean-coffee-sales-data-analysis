-- Total Customer by cities
select  City , count(DISTINCT Customer_ID)  as Total_Customers
from DatasetForCoffeeSales2
group by City
order by Total_Customers desc

-- total customer branch  
select DISTINCT Customer_ID , count ( city) as total_branch
from DatasetForCoffeeSales2
group by  Customer_ID 
order by total_branch desc

-- total order by customer
select  DISTINCT Customer_ID , count(*)  as Total_order
from DatasetForCoffeeSales2
group by Customer_ID
order by Total_order desc

--  price for each producr 
select distinct Product , Unit_Price
from DatasetForCoffeeSales2

-- total revnue generated for each product 

select Product , sum(Final_Sales) as Total_revenue
from DatasetForCoffeeSales2
group by Product


-- what total revenue generated ny each customer
select distinct Customer_ID , sum(Final_Sales) as Total_revenue
from DatasetForCoffeeSales2
group by  Customer_ID
order by Total_revenue desc

-- what total revenue generated ny each city
select distinct City , sum(Final_Sales) as Total_revenue
from DatasetForCoffeeSales2
group by  City
order by Total_revenue desc

-- total order for each city 
select  City , count(*) as total_order
from DatasetForCoffeeSales2
group by  City
order by total_order desc