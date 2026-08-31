-- Question 1 (INNER JOIN)
-- Write a query to show all orders with customer first name,
-- last name, and email. Use INNER JOIN.

-- ANSWER:
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    c.first_name,
    c.last_name,
    c.email
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

-- =========================================================
-- Question 2 (LEFT JOIN + NULL Check)
-- Write a query to find all customers who have NOT placed
-- any orders. Use LEFT JOIN and check for NULL.
-- =========================================================

-- ANSWER:
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer,
    c.email,
    c.customer_segment
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;

/*
  Expected Output:
  Shows customers with no orders (o.order_id IS NULL)
  Example: Amber Saxena (customer_id = 46) if she has no orders
*/

-- =========================================================
-- Question 3 (Multiple JOINs)
-- Write a query to show order_id, product_name, quantity,
-- and unit_price for all orders.
-- (Hint: orders, order_items, and products tables)
-- =========================================================

-- ANSWER:
SELECT 
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id, oi.order_item_id;

/*
  Expected Output:
  Shows each order with its products and quantities
  Example: Order 1001 → MacBook Pro 16" (1), Logitech MX Master 3S (3)
*/

-- =========================================================
-- Question 4 (LEFT JOIN with Aggregation)
-- Write a query to show all products with:
-- - product_name
-- - total_quantity_sold (SUM of quantity from order_items)
-- Use COALESCE to show 0 for products never sold.
-- =========================================================

-- ANSWER:
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold,
    COALESCE(ROUND(SUM(oi.quantity * oi.unit_price), 2), 0) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category, p.price
ORDER BY total_quantity_sold DESC;

/*
  Expected Output:
  Shows all products with total sales
  Products never sold show 0 for total_quantity_sold
  Example: NutriBullet Pro → 0 sold (if never ordered)
*/

-- =========================================================
-- Question 5 (SELF JOIN)
-- Write a query to find customers who live in the same city.
-- Show: customer1, city, customer2
-- Use SELF JOIN and a.customer_id < b.customer_id to avoid duplicates.
-- =========================================================

-- ANSWER:
SELECT 
    a.first_name || ' ' || a.last_name AS customer1,
    a.city,
    b.first_name || ' ' || b.last_name AS customer2
FROM customers a
INNER JOIN customers b ON a.city = b.city
WHERE a.customer_id < b.customer_id
ORDER BY a.city, a.first_name, b.first_name;

/*
  Expected Output:
  Shows pairs of customers in the same city
  Example: If John Smith and Nancy Lopez both in New York:
  customer1: John Smith  | city: New York | customer2: Nancy Lopez
*/

-- =========================================================
-- BONUS: All 5 Queries Combined (One SELECT per Query)
-- =========================================================

-- Query 1: INNER JOIN
SELECT 
    o.order_id,
    c.first_name,
    c.last_name,
    c.email,
    o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
LIMIT 5;

-- Query 2: LEFT JOIN (Customers with no orders)
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer,
    c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Query 3: Multiple JOINs
SELECT 
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
LIMIT 10;

-- Query 4: LEFT JOIN with Aggregation
SELECT 
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) AS total_sold
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 10;

-- Query 5: SELF JOIN
SELECT 
    a.first_name || ' ' || a.last_name AS customer1,
    a.city,
    b.first_name || ' ' || b.last_name AS customer2
FROM customers a
INNER JOIN customers b ON a.city = b.city
WHERE a.customer_id < b.customer_id;

-- =========================================================
-- Quick Reference
-- =========================================================

/*
  Question | Topic                    | Key Concept
  ---------|--------------------------|-------------------------
  1        | INNER JOIN               | Only matching rows
  2        | LEFT JOIN + NULL Check   | Find non-matches
  3        | Multiple JOINs           | 3 tables: orders → items → products
  4        | LEFT JOIN + Aggregation  | COALESCE for NULL handling
  5        | SELF JOIN                | Join table to itself
*/
