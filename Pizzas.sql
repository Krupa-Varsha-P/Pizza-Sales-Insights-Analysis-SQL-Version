SELECT * FROM pizza_sales.pizzas;

#Examining presence of NULL in pizzas:
SELECT * FROM pizza_sales.pizzas where pizza_id is null or pizza_type_id is null or size is null or price is null ; /*Ans: Empty rows*/
SELECT count(*) FROM pizza_sales.pizzas where pizza_id is null or pizza_type_id is null or size is null or price is null; /*Ans: 0*/

#Examining presence of Duplicate Rows in pizzas:
select pizza_id,count(pizza_id) from pizza_sales.pizzas GROUP BY pizza_id having count(pizza_id)>1;