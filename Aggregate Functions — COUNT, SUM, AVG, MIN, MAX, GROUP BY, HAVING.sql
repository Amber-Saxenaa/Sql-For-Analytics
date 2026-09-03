/*
========================================================
  Aggregate Functions — COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
  Database: practise (customers, orders, order_items, products)
========================================================
  Purpose: Summarize and analyze data using aggregate functions
  Author: Amber
  Date: 2026-09-03
========================================================
*/

-- =========================================================
-- 1. COUNT() — Count Rows
-- =========================================================

-- Count total customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Count customers with phone numbers (non-NULL)
SELECT COUNT(phone) AS customers_with_phone
FROM customers;

-- Count distinct customer segments
SELECT COUNT(DISTINCT customer_segment) AS unique_segments
FROM customers;

-- Count customers from California
SELECT COUNT(*) AS california_customers
FROM customers
WHERE state = 'CA';

-- Count total orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Count distinct customers who placed orders
SELECT COUNT(DISTINCT customer_id) AS unique_customers_with_orders
FROM orders;


-- =========================================================
-- 2. SUM() — Add Values
-- =========================================================

-- Total revenue from all orders
SELECT SUM(total_amount) AS total_revenue
FROM orders;

-- Revenue from completed orders only
SELECT SUM(total_amount) AS completed_revenue
FROM orders
WHERE order_status = 'Completed';

-- Total quantity of all items sold
SELECT SUM(quantity) AS total_items_sold
FROM order_items;

-- Total inventory value (price × stock)
SELECT SUM(price * stock_quantity) AS total_inventory_value
FROM products;

-- Total revenue from Electronics products
SELECT ROUND(SUM(oi.quantity * oi.unit_price), 2) AS electronics_revenue
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Electronics';


-- =========================================================
-- 3. AVG() — Average
-- =========================================================

-- Average order value
SELECT ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders;

-- Average product price
SELECT ROUND(AVG(price), 2) AS avg_product_price
FROM products;

-- Average price of Electronics products
SELECT ROUND(AVG(price), 2) AS avg_electronics_price
FROM products
WHERE category = 'Electronics';

-- Average quantity per order item
SELECT ROUND(AVG(quantity), 2) AS avg_quantity_per_item
FROM order_items;


-- =========================================================
-- 4. MIN() — Minimum Value
-- =========================================================

-- Cheapest product
SELECT MIN(price) AS cheapest_price
FROM products;

-- Oldest customer (earliest registration)
SELECT MIN(registration_date) AS oldest_customer
FROM customers;

-- Smallest order
SELECT MIN(total_amount) AS smallest_order
FROM orders;


-- =========================================================
-- 5. MAX() — Maximum Value
-- =========================================================

-- Most expensive product
SELECT MAX(price) AS most_expensive
FROM products;

-- Newest customer (latest registration)
SELECT MAX(registration_date) AS newest_customer
FROM customers;

-- Largest order
SELECT MAX(total_amount) AS largest_order
FROM orders;


-- =========================================================
-- 6. All Aggregates Together
-- =========================================================

-- Complete customer summary
SELECT 
    COUNT(*) AS total_customers,
    MIN(registration_date) AS oldest_customer,
    MAX(registration_date) AS newest_customer,
    COUNT(DISTINCT state) AS states_covered,
    COUNT(DISTINCT customer_segment) AS unique_segments
FROM customers;

-- Complete order summary
SELECT 
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    MIN(total_amount) AS smallest_order,
    MAX(total_amount) AS largest_order
FROM orders;

-- Complete product summary
SELECT 
    COUNT(*) AS total_products,
    ROUND(AVG(price), 2) AS avg_price,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive,
    SUM(stock_quantity) AS total_stock
FROM products;


-- =========================================================
-- 7. GROUP BY — Group Rows
-- =========================================================

-- Count customers by segment
SELECT 
    customer_segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_segment
ORDER BY total_customers DESC;

-- Count customers by state
SELECT 
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;

-- Count orders by status
SELECT 
    order_status,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- Count products by category
SELECT 
    category,
    COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;

-- Average price by category
SELECT 
    category,
    ROUND(AVG(price), 2) AS avg_price,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive
FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- Total quantity sold by product
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC;

-- Total revenue by customer segment (using JOIN)
SELECT 
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
ORDER BY total_revenue DESC;


-- =========================================================
-- 8. GROUP BY with Multiple Columns
-- =========================================================

-- Count customers by segment and state
SELECT 
    customer_segment,
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_segment, state
ORDER BY customer_segment, customer_count DESC;

-- Total revenue by customer segment and order status
SELECT 
    c.customer_segment,
    o.order_status,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_segment, o.order_status
ORDER BY c.customer_segment, total_revenue DESC;

-- Product summary by category and supplier
SELECT 
    category,
    supplier,
    COUNT(*) AS product_count,
    ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category, supplier
ORDER BY category, product_count DESC;


-- =========================================================
-- 9. HAVING — Filter Groups
-- =========================================================

-- Segments with more than 5 customers
SELECT 
    customer_segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_segment
HAVING COUNT(*) > 5
ORDER BY total_customers DESC;

-- States with more than 2 customers
SELECT 
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY state
HAVING COUNT(*) > 2
ORDER BY customer_count DESC;

-- Categories with average price > $500
SELECT 
    category,
    ROUND(AVG(price), 2) AS avg_price,
    COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING AVG(price) > 500
ORDER BY avg_price DESC;

-- Categories with more than 5 products AND avg price > $300
SELECT 
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category
HAVING COUNT(*) > 5
   AND AVG(price) > 300
ORDER BY avg_price DESC;

-- Customers who have spent more than $3000 total
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > 3000
ORDER BY total_spent DESC;


-- =========================================================
-- 10. WHERE vs HAVING (Combined Example)
-- =========================================================

-- Step 1: WHERE filters individual products (only Electronics)
-- Step 2: GROUP BY groups by supplier
-- Step 3: HAVING filters groups (suppliers with 2+ products)

SELECT 
    supplier,
    COUNT(*) AS product_count,
    ROUND(AVG(price), 2) AS avg_price
FROM products
WHERE category = 'Electronics'          -- Filters rows
GROUP BY supplier
HAVING COUNT(*) >= 2                    -- Filters groups
ORDER BY avg_price DESC;


-- =========================================================
-- 11. Real-World Analysis Examples
-- =========================================================

-- Sales by year
SELECT 
    YEAR(order_date) AS year,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS revenue,
    ROUND(AVG(total_amount), 2) AS avg_order
FROM orders
GROUP BY YEAR(order_date)
ORDER BY year DESC;

-- Sales by month
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Top 5 customers by spending
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer,
    COUNT(o.order_id) AS order_count,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

-- Product performance by category
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS unique_products,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_line_item
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- =========================================================
-- 12. Practice Exercises
-- =========================================================

/*
-- 1. Count total number of customers
SELECT COUNT(*) AS total_customers FROM customers;

-- 2. Count customers from California (CA)
SELECT COUNT(*) FROM customers WHERE state = 'CA';

-- 3. Calculate total revenue from all orders
SELECT SUM(total_amount) AS total_revenue FROM orders;

-- 4. Calculate average product price
SELECT ROUND(AVG(price), 2) AS avg_price FROM products;

-- 5. Find the most expensive product
SELECT MAX(price) AS most_expensive FROM products;

-- 6. Count customers by customer_segment (GROUP BY)
SELECT customer_segment, COUNT(*) FROM customers GROUP BY customer_segment;

-- 7. Count products by category (GROUP BY)
SELECT category, COUNT(*) FROM products GROUP BY category;

-- 8. Find categories with more than 5 products (HAVING)
SELECT category, COUNT(*) FROM products GROUP BY category HAVING COUNT(*) > 5;

-- 9. Average price by category, show only categories with avg > $500
SELECT category, ROUND(AVG(price), 2) AS avg_price 
FROM products 
GROUP BY category 
HAVING AVG(price) > 500;

-- 10. Customers who have spent more than $2000
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > 2000;
*/


-- =========================================================
-- Quick Reference
-- =========================================================

/*
  Function    | Purpose                    | Example
  ------------|----------------------------|-------------------------
  COUNT(*)    | Count all rows             | COUNT(*) AS total
  COUNT(col)  | Count non-NULL values      | COUNT(phone)
  COUNT(DISTINCT) | Count unique values    | COUNT(DISTINCT state)
  SUM(col)    | Add up values              | SUM(total_amount)
  AVG(col)    | Calculate average          | AVG(price)
  MIN(col)    | Find minimum               | MIN(price)
  MAX(col)    | Find maximum               | MAX(price)
  GROUP BY    | Group rows                 | GROUP BY category
  HAVING      | Filter groups              | HAVING COUNT(*) > 5
*/

/*
  Key Takeaways:
  - WHERE filters rows, HAVING filters groups
  - GROUP BY groups rows for aggregation
  - Always use COALESCE for NULL handling in aggregations
  - ORDER BY can use aliases (e.g., ORDER BY avg_price DESC)
  - INNER JOIN is often used with GROUP BY for multi-table analysis
*/
