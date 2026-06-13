use super_schema;
select * from super;

#Create a duplicate dataset
drop table if exists super1;
CREATE TABLE `super1` (
  `order_id` text,
  `order_date` text,
  `ship_date` text,
  `ship_mode` text,
  `customer_id` text,
  `customer_name` text,
  `segment` text,
  `country` text,
  `city` text,
  `state` text,
  `postal_code` text,
  `region` text,
  `product_id` text,
  `category` text,
  `Sub_Category` text,
  `product_name` text,
  `sales` double DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `profit` double DEFAULT NULL,
  `profit_margin` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into super1
select * from super;

select * from super1;
select count(*) from super1;

#Data Cleaning
#Check Null Values

select * from super1
where order_id is null
or order_date is null
or ship_date is null
or ship_mode is null
or customer_id is null
or customer_name is null
or segment is null
or country is null
or city is null
or state is null
or postal_code is null
or region is null
or product_id is null
or category is null
or sales is null;

#Check duplicate values
With emp as(
select * ,row_number() over(partition by order_id ,
 order_date ,
 ship_date ,
 ship_mode ,
 customer_id ,
 customer_name ,
 segment ,
 country ,
 city ,
 state ,
 postal_code ,
 region ,
 product_id ,
 category ,
 sales,
  Quantity,
  Discount,
  Profit order by order_id) as rn from super1)
  select * from emp where rn > 1;
  
  #Convert dates
  select * from super1;
  update super1
  set order_date = str_to_date(order_date,'%d-%m-%Y');
  
  alter table super1
  modify column order_date date;
  
   select * from super1;
  update super1
  set ship_date = str_to_date(ship_date,'%d-%m-%Y');
  
  alter table super1
  modify column ship_date date;
  
  #Check discount greater than zero
  select * from super1
  where discount > 0;
  
  #Data Cleaning finished
  
  #Exploratory SQL Analysis
  #Total Sales
  select round(sum(sales),2) as total_sales from super1;
  
  #Total Profit
  select round(sum(profit),2) as total_profit from super1;
  
  #Average Order Value
  select round(avg(sales),2) as avg_order_value from super1;
  
  #Total Customer
  select count(distinct customer_id) as total_customer from super1;

  #Total Orders
  select count(distinct order_id) as total_orders from super1;
  
  #Exploratory analysis finished
  
  #Business query
  #Monthly Sales trend for year 2017
  select month(order_date) as month, round(sum(sales),2) as total_sales from super1
  where year(order_date) = 2017
  group by month(order_date) 
  order by month ;
  
  #Year-wise Sales
  select year(order_date) as year , round(sum(sales),2) as total_sales from super1
  group by year(order_date)
  order by year(order_date);
  
  #Region-wise Sales
  select region , round(sum(sales),2) as total_sales from super1
  group by region;
  
  #State-wise Sales
  select state , round(sum(sales),2) as total_sales from super1
  group by state;
  
  #Category Analysis
  select category , round(sum(sales),2) as total_sales from super1
  group by category;
  
  #Sub-Category Analysis
  select sub_category , round(sum(sales),2) as total_sales from super1
  group by sub_category;
  
  #Top 10 Products
  select product_name,round(sum(sales),2) as total_sales from super1
  group by product_name
  order by total_sales desc
  limit 10;
  
  #Top 10 Customers
  select customer_id,customer_name,round(sum(sales),2) as sales from super1
  group by customer_id,customer_name
  order by sales desc limit 10;
  
  #Profit Analysis
  select region,round(sum(profit),2) as total_profit from super1
  group by region;
  
  #Loss-making Products
  select product_name,round(sum(profit),2) as total_loss from super1
  group by product_name
  having round(sum(profit),2) < 0
  order by round(sum(profit),2) desc;
  
  #Top customer in each region
  With top as(
  select customer_id,customer_name,region,round(sum(sales),2) as total_sales , rank() over(partition by region order by sum(sales) desc) as rn from super1
  group by customer_id,region,customer_name)
  select * from top where rn = 1;
  

