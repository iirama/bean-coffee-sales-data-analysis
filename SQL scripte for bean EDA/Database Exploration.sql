-- Explore all object in the database
select * from INFORMATION_SCHEMA.TABLES

-- Explore all columns in databse

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'DatasetForCoffeeSales2'