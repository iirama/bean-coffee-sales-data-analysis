/*===========================================================================================
------------------------------------ change over time ---------------------------------------
=============================================================================================*/

-- by year
select 
DATETRUNC(year , Date) as order_date,  
sum(Final_Sales) as total_sales,
count(Distinct Customer_ID) as Total_customer,
sum(Quantity) as total_quantity
from DatasetForCoffeeSales2
group by DATETRUNC(year , Date) 
order by DATETRUNC(year , Date)

--  by year and month 
select 
DATETRUNC(month , Date) as order_date,  
sum(Final_Sales) as total_sales,
count(Distinct Customer_ID) as Total_customer,
sum(Quantity) as total_quantity
from DatasetForCoffeeSales2
group by DATETRUNC(month , Date) 
order by DATETRUNC(month , Date)

