# 🍕 Pizzahut SQL Analysis

This file contains SQL queries and their explanations in a simple, readable format.

---

## 1️⃣ Retrieve the total number of orders placed

    ```sql
    SELECT COUNT(order_id) AS total_orders
    FROM orders;
    
    Calculate the total revenue generated from pizza sales
    SELECT ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
    FROM pizzas p
    JOIN order_details o ON p.pizza_id = o.pizza_id;```


Joins pizzas with order_details.

Multiplies quantity × price for each pizza.

Sums the result and rounds to 2 decimal places.

3️⃣ Identify the highest-priced pizza
WITH cte AS (
    SELECT t.name, p.price 
    FROM pizzas p
    JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id
)
SELECT name, MAX(price) OVER() AS max_price
FROM cte
LIMIT 1;


Finds pizza names with their prices.

Uses MAX(price) to identify the most expensive pizza.

Returns the name and highest price.

4️⃣ Identify the most common pizza size ordered
SELECT pizzas.size, COUNT(order_details_id) AS order_count
FROM pizzas
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;


Groups all orders by pizza size.

Counts how many orders were placed for each size.

Sorts results by highest count first.

5️⃣ List the top 5 most ordered pizza types
SELECT pt.name, SUM(quantity) total_quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details o ON o.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_quantity DESC
LIMIT 5;


Joins pizza_types, pizzas, and order_details.

Sums total quantity ordered for each pizza type.

Shows the top 5 pizza types.

6️⃣ Total quantity of pizzas ordered by category
SELECT SUM(quantity) AS total_quantity, category
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY category;


Groups pizzas by category.

Sums up total quantities ordered.

7️⃣ Distribution of orders by hour of the day
SELECT COUNT(order_id) AS total_order, HOUR(order_time) AS order_per_hr
FROM orders
GROUP BY order_per_hr
ORDER BY order_per_hr;


Extracts hour from order_time.

Counts how many orders were placed in each hour.

Sorts by hour in ascending order.

8️⃣ Category-wise distribution of pizzas
SELECT COUNT(name) AS name_wise_count, category
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
GROUP BY category;


Groups pizzas by category.

Counts number of pizza names in each category.

9️⃣ Average number of pizzas ordered per day
WITH cte AS (
    SELECT order_date, SUM(quantity) AS total_quantity
    FROM orders o
    JOIN order_details od ON od.order_id = o.order_id
    GROUP BY order_date
)
SELECT ROUND(AVG(total_quantity), 2) AS average_order_of_pizzas
FROM cte;


Calculates total pizzas ordered for each date.

Then finds the average across all days.

🔟 Top 3 most ordered pizza types based on revenue
SELECT name, ROUND(SUM(quantity * price)) revenue
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY name
ORDER BY revenue DESC
LIMIT 3;


Computes revenue for each pizza type (quantity × price).

Sorts in descending order.

Returns top 3 pizzas by revenue.

1️⃣1️⃣ Percentage contribution of each pizza category to total revenue
WITH cte AS (
    SELECT category, ROUND(SUM(quantity * price)) revenue
    FROM pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od ON p.pizza_id = od.pizza_id
    GROUP BY category
),
sum_data AS (
    SELECT SUM(revenue) AS total_revenue FROM cte
)
SELECT category, ROUND((revenue / total_revenue) * 100, 2) AS percentage
FROM cte, sum_data;


Calculates revenue per pizza category.

Divides each category’s revenue by total revenue.

Returns percentage contribution.

1️⃣2️⃣ Cumulative revenue generated over time
SELECT order_date,
       SUM(revenue) OVER(ORDER BY order_date) AS cum_revenue
FROM (
    SELECT o.order_date, ROUND(SUM(od.quantity * p.price)) revenue
    FROM order_details od
    JOIN orders o ON o.order_id = od.order_id
    JOIN pizzas p ON p.pizza_id = od.pizza_id
    GROUP BY order_date
) AS sales;


Groups daily revenue by order_date.

Uses window function to calculate cumulative sum over time.

1️⃣3️⃣ Top 3 most ordered pizza types by revenue for each category
WITH cte AS (
    SELECT category, name, revenue,
           RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS ranking
    FROM (
        SELECT category, name, ROUND(SUM(od.quantity * p.price)) revenue
        FROM pizzas p
        JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        JOIN order_details od ON p.pizza_id = od.pizza_id
        GROUP BY name, category
    ) AS sales
)
SELECT category, name, revenue, ranking AS top
FROM cte
WHERE ranking < 4;


Groups pizzas by category and revenue.

Uses RANK() to rank pizzas within each category.

Selects the top 3 per category.


---

👉 This file (`queries.md`) is **clean, organized, and GitHub-ready**.  

Do you also want me to generate a **short project introduction + setup instructions** at the top (like how to import CSV, run queries, etc.) so it looks like a professional data analysis project?

You said:
just write it in only one container where i can easily copy 
ChatGPT said:

Got it 👍 I'll put the entire queries.md file in a single fenced block so you can just copy-paste directly into GitHub.

Here it is ⬇️

# 🍕 Pizzahut SQL Analysis

This file contains SQL queries and their explanations in a simple, readable format.

---

## 1️⃣ Retrieve the total number of orders placed

```sql
SELECT COUNT(order_id) AS total_orders
FROM orders;


Counts how many orders have been placed.

Returns a single number (total_orders).

2️⃣ Calculate the total revenue generated from pizza sales
SELECT ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM pizzas p
JOIN order_details o ON p.pizza_id = o.pizza_id;


Joins pizzas with order_details.

Multiplies quantity × price for each pizza.

Sums the result and rounds to 2 decimal places.

3️⃣ Identify the highest-priced pizza
WITH cte AS (
    SELECT t.name, p.price 
    FROM pizzas p
    JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id
)
SELECT name, MAX(price) OVER() AS max_price
FROM cte
LIMIT 1;


Finds pizza names with their prices.

Uses MAX(price) to identify the most expensive pizza.

Returns the name and highest price.

4️⃣ Identify the most common pizza size ordered
SELECT pizzas.size, COUNT(order_details_id) AS order_count
FROM pizzas
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;


Groups all orders by pizza size.

Counts how many orders were placed for each size.

Sorts results by highest count first.

5️⃣ List the top 5 most ordered pizza types
SELECT pt.name, SUM(quantity) total_quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details o ON o.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_quantity DESC
LIMIT 5;


Joins pizza_types, pizzas, and order_details.

Sums total quantity ordered for each pizza type.

Shows the top 5 pizza types.

6️⃣ Total quantity of pizzas ordered by category
SELECT SUM(quantity) AS total_quantity, category
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY category;


Groups pizzas by category.

Sums up total quantities ordered.

7️⃣ Distribution of orders by hour of the day
SELECT COUNT(order_id) AS total_order, HOUR(order_time) AS order_per_hr
FROM orders
GROUP BY order_per_hr
ORDER BY order_per_hr;


Extracts hour from order_time.

Counts how many orders were placed in each hour.

Sorts by hour in ascending order.

8️⃣ Category-wise distribution of pizzas
SELECT COUNT(name) AS name_wise_count, category
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
GROUP BY category;


Groups pizzas by category.

Counts number of pizza names in each category.

9️⃣ Average number of pizzas ordered per day
WITH cte AS (
    SELECT order_date, SUM(quantity) AS total_quantity
    FROM orders o
    JOIN order_details od ON od.order_id = o.order_id
    GROUP BY order_date
)
SELECT ROUND(AVG(total_quantity), 2) AS average_order_of_pizzas
FROM cte;


Calculates total pizzas ordered for each date.

Then finds the average across all days.

🔟 Top 3 most ordered pizza types based on revenue
SELECT name, ROUND(SUM(quantity * price)) revenue
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY name
ORDER BY revenue DESC
LIMIT 3;


Computes revenue for each pizza type (quantity × price).

Sorts in descending order.

Returns top 3 pizzas by revenue.

1️⃣1️⃣ Percentage contribution of each pizza category to total revenue
WITH cte AS (
    SELECT category, ROUND(SUM(quantity * price)) revenue
    FROM pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od ON p.pizza_id = od.pizza_id
    GROUP BY category
),
sum_data AS (
    SELECT SUM(revenue) AS total_revenue FROM cte
)
SELECT category, ROUND((revenue / total_revenue) * 100, 2) AS percentage
FROM cte, sum_data;


Calculates revenue per pizza category.

Divides each category’s revenue by total revenue.

Returns percentage contribution.

1️⃣2️⃣ Cumulative revenue generated over time
SELECT order_date,
       SUM(revenue) OVER(ORDER BY order_date) AS cum_revenue
FROM (
    SELECT o.order_date, ROUND(SUM(od.quantity * p.price)) revenue
    FROM order_details od
    JOIN orders o ON o.order_id = od.order_id
    JOIN pizzas p ON p.pizza_id = od.pizza_id
    GROUP BY order_date
) AS sales;


Groups daily revenue by order_date.

Uses window function to calculate cumulative sum over time.

1️⃣3️⃣ Top 3 most ordered pizza types by revenue for each category
WITH cte AS (
    SELECT category, name, revenue,
           RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS ranking
    FROM (
        SELECT category, name, ROUND(SUM(od.quantity * p.price)) revenue
        FROM pizzas p
        JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        JOIN order_details od ON p.pizza_id = od.pizza_id
        GROUP BY name, category
    ) AS sales
)
SELECT category, name, revenue, ranking AS top
FROM cte
WHERE ranking < 4;


Groups pizzas by category and revenue.

Uses RANK() to rank pizzas within each category.

Selects the top 3 per category.
