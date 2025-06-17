/*===========================================================================================
------------------------------------- Data Segmentation -------------------------------------
=============================================================================================*/

-- product segment based on price

with product_segment as (
select 
Product,
Unit_Price,
case when Unit_Price < 30 then 'Below 30'
	 when Unit_Price between 30 and 40 then '30 - 40'
	 when Unit_Price between 40 and 45 then '40 - 45'
	 else 'Above 45'
end price_range	 
from DatasetForCoffeeSales2)

select 
price_range , 
count(Distinct Product) as total_product
from product_segment
group by price_range;


-- city segment based on spedning behavor
with city_segment as(
select 
City,
sum(Final_Sales) as total_sales,
count(*) as total_order,
min(Date) as first_order,
max(Date) as last_order,
datediff(month , min(Date) , max (Date)) as lifespan
from DatasetForCoffeeSales2
group by City )

select 
City , 
total_sales,
total_order,

case when  total_sales > 70000 and total_order >= 75 then 'very high demand'
	 when  total_sales >= 50000  and total_order >= 66  then 'high demand'
	 when  total_sales >= 30000 and total_order >= 60  then 'ruglar demand'
	 else 'Low'
end city_segmanton
from city_segment



