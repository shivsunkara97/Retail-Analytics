use test;
select * from test.order_details;
select * from orders;
-- order id primary key
select * from pizza_types;
select * from pizzas;


-- Joining all tables

select *
from order_details as a
left join orders as b
on a.order_id=b.order_id;

-- What are the most popular pizza types?
-- 1.Popularity by Order Value
select d.name,sum(a.quantity) as Total_qty,sum(a.quantity)*sum(c.price) as Order_Value
from order_details as a left join orders as b 
on a.order_id=b.order_id
left join pizzas as c
on a.pizza_id=c.pizza_id
left join pizza_types as d
on c.pizza_type_id=d.pizza_type_id
group by d.name
order by Order_Value desc
limit 5;




-- 2.Popularity by Quantity
select d.name,sum(a.quantity) as Total_qty,sum(a.quantity)*sum(c.price) as Order_Value
from order_details as a left join orders as b 
on a.order_id=b.order_id
left join pizzas as c
on a.pizza_id=c.pizza_id
left join pizza_types as d
on c.pizza_type_id=d.pizza_type_id
group by d.name
order by Total_qty desc
limit 5;





-- 3.What is the average transaction size or number of pizzas per order?
-- merging entire data
create table Pizza_info as
select a.order_id,a.pizza_id,a.quantity,b.date,b.time,c.price,d.name
FROM order_details a 
JOIN pizzas c ON a.pizza_id = c.pizza_id
JOIN pizza_types d ON c.pizza_type_id = d.pizza_type_id
JOIN orders b ON a.order_id = b.order_id;

-- 3.1.avg trasaction size
select avg(total_price) as Avg_Trasaction
from (select order_id,sum(quantity*price) as total_price
from Pizza_info
group by order_id) as order_totals;

-- 3.2.avg number of pizza
select avg(total_quantity) as Avg_order_size
from (select order_id,sum(quantity) as total_quantity
from Pizza_info
group by order_id) as order_totals;






-- 4.weekdays vs weekend sales
select case when weekday(date)<5 then 'Weekday' else 'Weekend' end as day_type,sum(quantity*price) as Sales
from Pizza_info
group by case when weekday(date)<5 then 'Weekday' else 'Weekend' end;








select * from Pizza_info;

-- 5.number of orders each month
select MonthName(date) as Month_name,sum(quantity) as Total_Qty,round(sum(price),2) as Total_Amount,quantity*price as Total_Sales
from Pizza_info
group by Monthname(date);











-- 6.avg number of orders per day
select weekday(date) as Days,sum(order_id) as Total_Orders
from Pizza_info
group by weekday(date)
order by weekday(date);







-- 7.avg order size of each Pizza
select name,round(avg(quantity*price),2) as avg_order_size
from Pizza_info
group by name;


-- 8.Avg Sales on each Hour
select Hour(time) as Hrs,round(avg(quantity*price),2) as Avg_Sales
from Pizza_info
group by Hour(time)
order by Hour(time);
