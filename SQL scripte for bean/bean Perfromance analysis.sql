/*===========================================================================================
------------------------------------ Perfromance analysis -----------------------------------
=============================================================================================*/
with yearly_product_sales as (
select 
year(Date) as order_year,
Product as product_name,
sum(Final_Sales) as current_sales
from DatasetForCoffeeSales2
group by year(Date) ,Product)

select 
order_year,
product_name,
current_sales,
avg(current_sales) over (partition by product_name) as avg_sales,
current_sales - avg(current_sales) over (partition by product_name) as diff_avg,
case when current_sales - avg(current_sales) over (partition by product_name) >0 then  'Above Avg'
	 when current_sales - avg(current_sales) over (partition by product_name) <0 then 'Below Avg'
	 else 'Avg'
end Avg_changr,
lag (current_sales) over (partition by product_name order by order_year) as py_sales,
current_sales - lag (current_sales) over (partition by product_name order by order_year) as diff_py,

case when current_sales - lag (current_sales) over (partition by product_name order by order_year) >0 then  'Increase'
	 when current_sales - lag (current_sales) over (partition by product_name order by order_year) <0 then 'Descrease'
	 else 'No Chamge'
end py_change
from yearly_product_sales
order by product_name , order_year



with yearly_product_sales_by_city as (
select 
year(Date) as order_year,
City,
Product as product_name,
sum(Final_Sales) as current_sales
from DatasetForCoffeeSales2
group by year(Date) ,Product , City)

select 
order_year,
City ,
product_name,
current_sales,
avg(current_sales) over (partition by City , product_name) as avg_sales,
current_sales - avg(current_sales) over (partition by City , product_name) as diff_avg,
case when current_sales - avg(current_sales) over (partition by City , product_name) >0 then  'Above Avg'
	 when current_sales - avg(current_sales) over (partition by City , product_name) <0 then 'Below Avg'
	 else 'Avg'
end Avg_changr,
lag (current_sales) over (partition by City  , product_name order by order_year) as py_sales,
current_sales - lag (current_sales) over (partition by City , product_name order by order_year) as diff_py,

case when current_sales - lag (current_sales) over (partition by City , product_name order by order_year) >0 then  'Increase'
	 when current_sales - lag (current_sales) over (partition by City , product_name order by order_year) <0 then 'Descrease'
	 else 'No Chamge'
end py_change
from yearly_product_sales_by_city
order by product_name , order_year