-- Measure Exploration 

-- the total sales before and after discount and total dicount 

select sum(Sales_Amount) as Total_sales_before_Discount ,
sum(Discount_Amount) as Total_discount,
sum(Final_Sales) as Total_sales_after_Discount
from DatasetForCoffeeSales2


-- total item are sold
select sum(Quantity) as Total_Quantity
from DatasetForCoffeeSales2

-- average selling price
select avg(Unit_Price) as Avg_price
from DatasetForCoffeeSales2

-- Total order
select count(*) as Total_order from DatasetForCoffeeSales2

-- Total number of product 
select count(DISTINCT Product) as Total_product from DatasetForCoffeeSales2

-- Total number of customer 
select count(DISTINCT Customer_ID) as Total_Customer from DatasetForCoffeeSales2

-- Total order used discount
select COUNT(*) as Total_order_used_dic from DatasetForCoffeeSales2
where Used_Discount = 1

-- Total order used discount
select COUNT(*) as Total_order_not_used from DatasetForCoffeeSales2
where Used_Discount = 0


-- Generate report that show all key metrics of business

select 'Total_sales_before_Discount' as measure_name,sum(Sales_Amount) as measure_value 
from DatasetForCoffeeSales2
union all 
select 'Total_discount' as measure_name , sum(Discount_Amount) as measure_value
from DatasetForCoffeeSales2
union all 
select 'Total_sales_after_Discount' as measure_name , sum(Final_Sales) as measure_value
from DatasetForCoffeeSales2
union all 
select 'Total_Quantity' as  measure_name , sum(Quantity) as measure_value
from DatasetForCoffeeSales2
union all
select 'Avg_price' as  measure_name  ,avg(Unit_Price) as measure_value
from DatasetForCoffeeSales2
union all 
select 'Total_order' as  measure_name , count(*) as measure_value from DatasetForCoffeeSales2
union all 
select 'Total_product' as  measure_name , count(DISTINCT Product) as measure_value from DatasetForCoffeeSales2
union all 
select 'Total_Customer' as  measure_name , count(DISTINCT Customer_ID) as measure_value from DatasetForCoffeeSales2
union all
select 'Total_order_used_dic' as  measure_name , COUNT(*) as measure_value from DatasetForCoffeeSales2
where Used_Discount = 1
union all 
select 'Total_order_not_used' as  measure_name ,  COUNT(*) as measure_value from DatasetForCoffeeSales2
where Used_Discount = 0