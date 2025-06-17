/*===========================================================================================
---------------------------------------- Part of wohle --------------------------------------
=============================================================================================*/

-- by product
with product_sales as(
select 
Product,
sum(Final_Sales) as total_sales
from DatasetForCoffeeSales2
group by Product)

select 
Product,
total_sales,
sum (total_sales) over ()overall_sales,
concat(round ((CAST (total_sales as float) / sum (total_sales) over ())*100 , 2) , ' %')  as percentage_of_total
from product_sales
order by total_sales desc

-- by city 
with city_sales as(
select 
City,
sum(Final_Sales) as total_sales
from DatasetForCoffeeSales2
group by City)

select 
City,
total_sales,
sum (total_sales) over ()overall_sales,
concat(round ((CAST (total_sales as float) / sum (total_sales) over ())*100 , 2) , ' %')  as percentage_of_total
from city_sales
order by total_sales desc