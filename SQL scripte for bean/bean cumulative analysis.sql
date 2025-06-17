/*===========================================================================================
------------------------------------ Cumulative analysis ------------------------------------
=============================================================================================*/

-- total sales per month and the running total over time for each year
select 
order_date,
total_sales,
--window funcation
sum (total_sales) over ( partition by year(order_date) order by order_date)as running_total_sales,
avg (total_sales) over ( partition by year(order_date)  order by order_date)as running_avg_sales
from(
select 
DATETRUNC(month , Date) as order_date,
sum(Final_Sales) as total_sales
from DatasetForCoffeeSales2
group by DATETRUNC(month , Date)
) t