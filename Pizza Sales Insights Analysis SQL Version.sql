create database pizza_sales;
use pizza_sales;

#DATA CLEANING-> Correcting Date and Time data types:
alter table orders modify date DATE;
alter table orders modify time time;

#DATA TRANSFORMATION-> Joining(merging) pizza_type and pizzas tables:
create view pizza_details as 
select p.pizza_id,p.pizza_type_id,pt.name,pt.category,p.size,p.price,pt.ingredients 
from pizzas as p join pizza_types as pt 
on p.pizza_type_id = pt.pizza_type_id;
select * from pizza_details;

#Data Analysis
#KPI->Total Revenue
select round(sum(p.price*od.quantity)) as total_revenue from pizzas as p join order_details as od on p.pizza_id=od.pizza_id;

#KPI->Total Quantity Sold
select sum(quantity) as No_of_Pizzas_Sold from order_details;

#KPI->Total Orders
select count(order_id) as total_orders from orders;

#KPI->Average Order Value
select round(sum(p.price*od.quantity))/count(distinct(order_id)) as avg_order_value from pizzas as p join order_details as od on p.pizza_id=od.pizza_id;

#KPI-> Average Number of Pizzas per Order
select round(sum(quantity)/count(distinct(order_id))) as Avg_Pizzas_per_Order from order_details;

#SECTOR ANALYSIS
#-> Total Revenue & Total Number of Orders by Category 
select pt.category as Category, round(sum(p.price*od.quantity)) as Revenue_Category,count(distinct(od.order_id)) as Orders_Category
from pizzas as p join pizza_types as pt 
on pt.pizza_type_id=p.pizza_type_id  
join order_details as od 
on p.pizza_id=od.pizza_id
group by pt.category;

#-> Total Revenue & Total Number of Orders by Size
select p.size as Size, round(sum(p.price*od.quantity),2) as Revenue_Size,count(distinct(od.order_id)) as Orders_Size
from pizzas as p join order_details as od 
on p.pizza_id=od.pizza_id
group by p.size;

#Seasonal Analysis
#Hourly Sales Trends-> Total orders
alter table orders add meal_time text;
update orders set meal_time=null;
update orders set meal_time="9 AM-1 PM" where hour(orders.time) between 9 and 12;
update orders set meal_time="1 PM-4 PM" where hour(orders.time) between 13 and 15; 
update orders set meal_time="4 PM-7 PM" where hour(orders.time) between 16 and 18; 
update orders set meal_time="7 PM-10 PM" where hour(orders.time) between 19 and 21; 
update orders set meal_time="10 PM-12 AM" where hour(orders.time) between 22 and 23;
update orders set meal_time="Other" where hour(orders.time) in(24,0,1,2,3,4,5,6,7,8);
#select time,meal_time from orders;
select meal_time, count(order_id) as No_of_Orders from pizza_sales.orders group by meal_time order by No_of_Orders desc; 

#Hourly Sales Trends-> Total Revenue

/*select orders.meal_time, sum(pizzas.price*order_details.quantity) as Revenue_Meal_Time  
from order_details join orders
on order_details.order_id=orders.order_id
join pizzas
on order_details.pizza_id=pizzas.pizza_id
group by orders.meal_time; 
*/ 
/*select orders.meal_time, (select sum(pizzas.price*order_details.quantity)  from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id) as Revenue_Meal_Time from orders group by meal_time;
*/

SELECT 
    orders.meal_time, 
    round(sum(OrderRevenue)) AS Revenue_Meal_Time
FROM 
    (SELECT 
         order_details.order_id,
         SUM(pizzas.price * order_details.quantity) AS OrderRevenue
     FROM 
         order_details
     JOIN 
         pizzas ON order_details.pizza_id = pizzas.pizza_id
     GROUP BY 
         order_details.order_id) AS OrderRevenues
JOIN 
    orders ON OrderRevenues.order_id = orders.order_id
GROUP BY 
    orders.meal_time;

#Seasonal Analysis
#Day-wise Trends
select dayname(orders.date) as Days_of_Week, count(orders.order_id) from orders group by dayname(orders.date) order by count(orders.order_id) desc;

#Seasonal Analysis
#Month-wise Trends
select monthname(orders.date) as Months_of_Year, count(orders.order_id) as Total_Orders from orders group by monthname(orders.date) order by count(orders.order_id) desc;

#Customer Sentiment Analysis
#Most Ordered Pizzas & Size
select pizza_details.name, pizza_details.size, sum(order_details.quantity) 
from pizza_details  
join order_details on order_details.pizza_id=pizza_details.pizza_id
group by pizza_details.name, pizza_details.size
order by sum(order_details.quantity) desc;

#Most Ordered Pizzas
select pizza_details.name, sum(order_details.quantity) 
from pizza_details  
join order_details on order_details.pizza_id=pizza_details.pizza_id
group by pizza_details.name
order by sum(order_details.quantity) desc limit 1;

#Top 5 Pizzas by Revenue
select pizza_details.name as Pizza_Name, sum(pizza_details.price*order_details.quantity) as Total_Revenue from pizza_details join order_details on pizza_details.pizza_id=order_details.pizza_id group by pizza_details.name order by Total_Revenue desc limit 5;

#Top 5 Pizzas by Sales
select pizza_details.name as Pizza_Name, sum(order_details.quantity) as Total_Quantity_Sold from pizza_details join order_details on pizza_details.pizza_id=order_details.pizza_id group by pizza_details.name order by Total_Quantity_Sold desc limit 5;

#Pizza Analysis
#Least Expensive Pizza
select name, price from pizza_details order by price asc limit 1;

#Most Expensive Pizza
select name, price from pizza_details order by price desc limit 1;
