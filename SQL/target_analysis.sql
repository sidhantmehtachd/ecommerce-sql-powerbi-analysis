--                                 =========================
--                                        EXPLORATION
--                                 =========================


# Data type of columns in "customers" table
DESCRIBE targetdb.customers;

# time range b/w which orders are placed
SELECT
MIN(order_purchase_timestamp) as first_time,
MAX(order_purchase_timestamp) as last_time
FROM orders;

#cities and states of customers who ordered in the time range

select 
c.customer_city, c.customer_state
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
WHERE YEAR(order_purchase_timestamp) BETWEEN 2016 AND 2018


--                                 =========================
--                                         ANALYSIS
--                                 =========================


# Trend in the number of orders placed over the past years

SELECT
YEAR(order_purchase_timestamp) AS YEAR,
COUNT(order_id) AS total_orders_yearly
FROM orders
GROUP BY YEAR
ORDER BY total_orders_yearly ASC

# Monthly Seasonality in terms of the number of orders being placed
SELECT
MONTH(order_purchase_timestamp) AS MONTH,
COUNT(order_id) AS total_orders_monthly
FROM orders
GROUP BY MONTH
ORDER BY total_orders_monthly DESC


# During what time of the day, do the Brazilian customers mostly place their orders? (Dawn(0-6), Morning(7-12), Afternoon(13-18) or Night(19-23))
WITH time_category AS 
(
    SELECT
        order_id, 
        CASE
            WHEN HOUR(order_purchase_timestamp) BETWEEN 0 AND 6 THEN "DAWN"
            WHEN HOUR(order_purchase_timestamp) BETWEEN 7 AND 12 THEN "MORNING"
            WHEN HOUR(order_purchase_timestamp) BETWEEN 13 AND 18 THEN "AFTERNOON"
            ELSE "NIGHT"
        END AS time_of_day
    FROM orders
)
SELECT
time_of_day,
count(order_id) AS total_orders
FROM time_category
GROUP BY time_of_day
ORDER BY total_orders DESC
 

--                                 =========================
--                                       STATE ANALYSIS
--                                 =========================


# Month on month number of orders placed in each state
select
DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS MoM,
count(order_id) AS total_orders,
c.customer_state as STATE
FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
GROUP BY MoM, STATE
order BY MoM DESC

# Distributation of customers across the states
SELECT
count(DISTINCT customer_unique_id) AS totalCustomers,
customer_state AS STATE
FROM customers
GROUP BY STATE
ORDER BY totalCustomers DESC


--                                 =========================
--                                     ECONOMIC ANALYSIS
--                                 =========================


# % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only).

WITH yearly_totals AS (
    SELECT
        EXTRACT(YEAR FROM order_purchase_timestamp) as YEAR,
        ROUND(SUM(P.payment_value),2) as total_payment
    FROM payments AS P
    JOIN orders AS O
        ON O.order_id = P.order_id
    WHERE 
        EXTRACT(YEAR FROM O.order_purchase_timestamp) IN (2017,2018)
        AND EXTRACT(MONTH FROM O.order_purchase_timestamp) BETWEEN 1 AND 8
    GROUP BY YEAR
    
)
SELECT
    ROUND((
        MAX(CASE WHEN YEAR = 2018 THEN total_payment END) -
        MAX(CASE WHEN YEAR = 2017 THEN total_payment END)
    )
    /
    MAX(CASE WHEN YEAR = 2017 THEN total_payment END )
    * 100,2
    ) AS percentage_diff
FROM yearly_totals;

# The Total & Average value of order price and order freight for each state.

SELECT
ROUND(SUM(price),2) AS total_val,
ROUND(AVG(price),2) AS avg_val,
ROUND(SUM(freight_value),2) AS total_fval,
ROUND(AVG(freight_value),2) AS avg_fval,
customer_state AS state
FROM orders AS O
JOIN order_items AS OI
ON O.order_id = OI.order_id
JOIN customers AS C
ON O.customer_id = C.customer_id
GROUP BY state


--                                 =========================
--                                     DELIVERY ANALYSIS
--                                 =========================


# The number of days taken to deliver each order from the purchase date 
# AND the difference between the estimated & actual delivery date of an order.

SELECT 
order_id,
TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) AS time_to_deliver,
TIMESTAMPDIFF(DAY,order_delivered_customer_date, order_estimated_delivery_date) AS diff_estimated_delivery
FROM orders;

# The top 5 states with the highest & lowest average freight value.

WITH avg_freight AS(
    SELECT
    ROUND(AVG(freight_value),2) AS avg_freight_val,
    customer_state AS STATE
    FROM orders AS O
    JOIN order_items AS OI
    ON O.order_id = OI.order_id
    JOIN customers AS C
    ON O.customer_id = C.customer_id
    GROUP BY STATE)
(
    SELECT STATE, avg_freight_val, "HIGHEST" AS Category
    FROM avg_freight
    ORDER BY avg_freight_val DESC
    LIMIT 5
)
UNION ALL
(
    SELECT STATE, avg_freight_val, "LOWEST" AS Category
    FROM avg_freight
    ORDER BY avg_freight_val ASC
    LIMIT 5
)

# The top 5 states with the highest & lowest average delivery time.

WITH avg_delivery_time AS (
    SELECT 
    customer_state AS STATE,
    AVG(TIMESTAMPDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date)) AS avg_time_of_delivery
    FROM orders AS O
    JOIN customers AS C
    ON O.customer_id = C.customer_id
    GROUP BY STATE
)
(
    SELECT STATE, avg_time_of_delivery, "HIGHEST" AS Category
    FROM avg_delivery_time
    ORDER BY avg_time_of_delivery DESC
    LIMIT 5 
)
UNION ALL
(
    SELECT STATE, avg_time_of_delivery, "lowest" AS Category
    FROM avg_delivery_time
    ORDER BY avg_time_of_delivery ASC
    LIMIT 5
)

# The top 5 states where the order delivery is really fast as compared to the estimated date of delivery.

SELECT
customer_state AS STATE,
AVG(TIMESTAMPDIFF(DAY,order_estimated_delivery_date,order_delivered_customer_date)) AS est_actual_avg
FROM orders AS O
JOIN customers AS C
ON O.customer_id = C.customer_id
GROUP BY STATE
ORDER BY est_actual_avg ASC
LIMIT 5


--                                 =========================
--                                      PAYMENT ANALYSIS
--                                 =========================


# Month on month number of orders placed using different payment types.

SELECT 
DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS MoM,
payment_type,
COUNT(DISTINCT O.order_id) AS total_orders
FROM payments AS P
JOIN orders AS O
on O.order_id = P.order_id
GROUP BY payment_type, MoM
ORDER BY MoM, total_orders DESC

# The number of orders placed on the basis of the payment installments that have been paid.

SELECT
payment_installments,
COUNT(DISTINCT order_id) as num_of_orders
from payments
WHERE payment_installments > 0
GROUP BY payment_installments
ORDER BY num_of_orders DESC


------------------------------------------------------------------------------------------------------------------------------------------