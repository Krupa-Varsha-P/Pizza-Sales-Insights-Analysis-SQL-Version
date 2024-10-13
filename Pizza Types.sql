SELECT * FROM pizza_sales.pizza_types;

#Examining presence of NULL in pizza_types:
SELECT * FROM pizza_sales.pizza_types where pizza_type_id is null or name is null or category is null or ingredients is null; /*Ans: Empty rows*/
SELECT count(*) FROM pizza_sales.pizza_types where pizza_type_id is null or name is null or category is null or ingredients is null; /*Ans: 0*/

#Examining presence of Duplicate Rows in pizza_types:
select pizza_type_id,count(pizza_type_id) from pizza_sales.pizza_types GROUP BY pizza_type_id having count(pizza_type_id)>1;