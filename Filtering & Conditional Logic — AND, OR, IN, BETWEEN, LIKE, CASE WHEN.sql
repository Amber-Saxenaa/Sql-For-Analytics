-- Premium customers from California
SELECT *
FROM customers
WHERE customer_segment = 'Premium'
  AND state = 'CA';

-- Electronics products over $1000 in stock
SELECT *
FROM products
WHERE category = 'Electronics'
  AND price > 1000
  AND stock_quantity > 0;

-- Completed orders over $2000
SELECT *
FROM orders
WHERE order_status = 'Completed'
  AND total_amount > 2000;


-- =========================================================
-- 2. OR — At least one condition must be true
-- =========================================================

-- Customers from CA or NY
SELECT *
FROM customers
WHERE state = 'CA'
   OR state = 'NY';

-- Products that are Electronics or Gaming
SELECT *
FROM products
WHERE category = 'Electronics'
   OR category = 'Gaming';

-- Orders that are Completed or Shipped
SELECT *
FROM orders
WHERE order_status = 'Completed'
   OR order_status = 'Shipped';


-- =========================================================
-- 3. AND + OR Combined (Use Parentheses!)
-- =========================================================

-- Premium or Regular customers from CA or NY
SELECT *
FROM customers
WHERE (customer_segment = 'Premium' OR customer_segment = 'Regular')
  AND (state = 'CA' OR state = 'NY');

-- Premium customers from CA or NY
SELECT *
FROM customers
WHERE customer_segment = 'Premium'
  AND (state = 'CA' OR state = 'NY');

-- Products NOT Electronics or Gaming
SELECT *
FROM products
WHERE NOT (category = 'Electronics' OR category = 'Gaming');


-- =========================================================
-- 4. IN — Match any value in a list
-- =========================================================

-- Customers from multiple states (cleaner than OR)
SELECT *
FROM customers
WHERE state IN ('CA', 'NY', 'TX', 'FL');

-- Products in specific categories
SELECT *
FROM products
WHERE category IN ('Electronics', 'Gaming', 'Accessories');

-- Orders with specific statuses
SELECT *
FROM orders
WHERE order_status IN ('Completed', 'Shipped', 'Delivered');

-- NOT IN (exclude values)
SELECT *
FROM customers
WHERE state NOT IN ('CA', 'NY', 'TX');

-- Products NOT in these categories
SELECT *
FROM products
WHERE category NOT IN ('Electronics', 'Gaming');

