SELECT * FROM pizza_sales.orders;

#Examining presence of NULL in orders:
SELECT * FROM pizza_sales.orders where order_id is null or date is null or time is null; /*Ans: Empty rows*/
SELECT count(*) FROM pizza_sales.orders where order_id is null or date is null or time is null; /*Ans: 0*/

#Examining presence of Duplicate Rows in orders:
select order_id,count(order_id) from pizza_sales.orders GROUP BY order_id having count(order_id)>1;