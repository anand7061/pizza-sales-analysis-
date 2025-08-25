create database pizzahut;
use pizzahut;
select * from pizzahut.orders;
select * from pizzahut.pizza_types;
select * from pizzahut.order_details;
select * from pizzas;

-- created the trable and then import the data from csv file 
CREATE TABLE pizzahut.orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE pizzahut.order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);


-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;



-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM
    pizzas p
        JOIN
    order_details o ON p.pizza_id = o.pizza_id;


-- Identify the highest-priced pizza.
with cte as(SELECT 
   t.name, p.price 
FROM
    pizzas p
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id)
    select name,max(price) over() as max_price from cte
    limit 1;

-- Identify the most common pizza size ordered.

SELECT 
    pizzas.size, COUNT(order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

-- List the top 5 most ordered pizza types along with their quantities.


SELECT 
    pt.name, SUM(quantity) total_quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_quantity DESC
LIMIT 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    SUM(quantity) AS total_quantity, category
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY category;

-- Determine the distribution of orders by hour of the day.
SELECT 
    COUNT(order_id) AS total_order,
    HOUR(order_time) AS order_per_hr
FROM
    orders
GROUP BY order_per_hr
ORDER BY order_per_hr;


-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    COUNT(name) AS name_wise_count, category
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
GROUP BY category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.
with cte as(SELECT 
    order_date, SUM(quantity) AS total_quantity
FROM
    orders o
        JOIN
    order_details od ON od.order_id = o.order_id
GROUP BY order_date)
SELECT 
    ROUND(AVG(total_quantity), 2) AS average_order_of_pizzas
FROM
    cte;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    name, ROUND(SUM(quantity * price)) revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY name
ORDER BY revenue DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

with cte as (SELECT 
    category, ROUND(SUM(quantity * price)) revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY category
ORDER BY revenue DESC),
sum_data as (SELECT 
    SUM(revenue) AS total_revenue
FROM
    cte)
SELECT 
    category, ROUND((revenue / total_revenue) * 100, 2)
FROM
    cte,
    sum_data;

-- Analyze the cumulative revenue generated over time.

SELECT 
order_date,
    SUM(revenue) over(order by order_date) AS cum_revenue
FROM
(SELECT 
    o.order_date, ROUND(SUM(od.quantity * p.price)) revenue
FROM
    order_details od
        JOIN
    orders o ON o.order_id = od.order_id
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id
GROUP BY order_date) as sales;



-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

with cte as(SELECT 
    category,name,revenue,
    rank()over(partition by category order by revenue desc) as ranking
FROM
(SELECT 
    category,name, ROUND(SUM(od.quantity * p.price)) revenue
FROM
    pizzas p
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        JOIN
   order_details od ON p.pizza_id = od.pizza_id
GROUP BY name,category) as sales)
select category,name,revenue,ranking as top from cte
where ranking <4;

