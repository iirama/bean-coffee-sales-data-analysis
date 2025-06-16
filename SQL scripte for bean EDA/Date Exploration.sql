--The date of the first and last order
-- how many month and year  between them 
select min(Date) as first_order ,
max(Date) as last_order ,
datediff(year ,min(Date)   ,max(Date))  as order_range_years,
datediff(month ,min(Date)   ,max(Date))  as order_range_month
from DatasetForCoffeeSales2

