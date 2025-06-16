-- the 1 top customer generated highest revenue

select top 5 Customer_ID  , sum(Final_Sales) as total_revenue 
from DatasetForCoffeeSales2
group by Customer_ID 
order by total_revenue desc

-- the 1 worst customer generated low revenue
select top 5 Customer_ID , sum(Final_Sales) as total_revenue 
from DatasetForCoffeeSales2
group by Customer_ID
order by total_revenue 
