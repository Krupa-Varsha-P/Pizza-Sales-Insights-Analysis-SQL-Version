SELECT * FROM pizza_sales.order_details;

#Examining presence of NULL in orders:
SELECT * FROM pizza_sales.order_details where order_details_id is null or order_id is null or pizza_id is null or quantity is null; /*Ans: Empty rows*/
SELECT count(*) FROM pizza_sales.order_details where order_details_id is null or order_id is null or pizza_id is null or quantity is null; /*Ans: 0*/

#Examining presence of Duplicate Rows in order_details:
select order_details_id,count(order_details_id) from pizza_sales.order_details GROUP BY order_details_id having count(order_details_id)>1;