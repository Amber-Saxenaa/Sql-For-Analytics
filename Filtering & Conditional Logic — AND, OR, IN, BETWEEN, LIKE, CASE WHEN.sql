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


-- =========================================================
-- 5. BETWEEN — Range filtering (inclusive)
-- =========================================================

-- Products priced between $100 and $500
SELECT *
FROM products
WHERE price BETWEEN 100 AND 500;

-- Orders from 2024
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Products with stock between 10 and 50
SELECT *
FROM products
WHERE stock_quantity BETWEEN 10 AND 50;

-- NOT BETWEEN (exclude range)
SELECT *
FROM products
WHERE price NOT BETWEEN 100 AND 500;


-- =========================================================
-- 6. LIKE — Pattern matching
-- =========================================================

-- Starts with 'J'
SELECT *
FROM customers
WHERE first_name LIKE 'J%';

-- Ends with 'gmail.com'
SELECT *
FROM customers
WHERE email LIKE '%gmail.com';

-- Contains 'Pro'
SELECT *
FROM products
WHERE product_name LIKE '%Pro%';

-- Exactly 4 letters starting with 'J'
SELECT *
FROM customers
WHERE first_name LIKE 'J___';

-- NOT LIKE (exclude pattern)
SELECT *
FROM customers
WHERE email NOT LIKE '%gmail.com';

-- Multiple LIKE conditions
SELECT *
FROM customers
WHERE email LIKE '%gmail.com'
   OR email LIKE '%yahoo.com';


-- =========================================================
-- 7. CASE WHEN — Conditional logic
-- =========================================================

-- Basic CASE: Price categories
SELECT 
    product_name,
    price,
    CASE 
        WHEN price < 100 THEN 'Budget'
        WHEN price < 500 THEN 'Mid-Range'
        WHEN price < 1000 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category
FROM products;

-- CASE with multiple conditions
SELECT 
    first_name,
    last_name,
    customer_segment,
    CASE 
        WHEN customer_segment = 'Premium' THEN 'High Priority'
        WHEN customer_segment = 'Regular' THEN 'Medium Priority'
        WHEN customer_segment = 'Student' THEN 'Low Priority'
        ELSE 'Other'
    END AS priority_level
FROM customers;

-- CASE with order status
SELECT 
    order_id,
    order_status,
    total_amount,
    CASE 
        WHEN order_status = 'Completed' THEN 'Closed'
        WHEN order_status = 'Shipped' THEN 'In Transit'
        WHEN order_status = 'Delivered' THEN 'Fulfilled'
        ELSE 'Processing'
    END AS order_stage
FROM orders;

-- CASE with numbers
SELECT 
    product_name,
    stock_quantity,
    CASE 
        WHEN stock_quantity = 0 THEN 'Out of Stock'
        WHEN stock_quantity < 10 THEN 'Low Stock'
        WHEN stock_quantity < 50 THEN 'In Stock'
        ELSE 'Well Stocked'
    END AS stock_status
FROM products;


-- =========================================================
-- 8. CASE with Aggregations (GROUP BY)
-- =========================================================

-- Count products by price category
SELECT 
    CASE 
        WHEN price < 100 THEN 'Budget'
        WHEN price < 500 THEN 'Mid-Range'
        WHEN price < 1000 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category,
    COUNT(*) AS product_count
FROM products
GROUP BY 
    CASE 
        WHEN price < 100 THEN 'Budget'
        WHEN price < 500 THEN 'Mid-Range'
        WHEN price < 1000 THEN 'Premium'
        ELSE 'Luxury'
    END
ORDER BY product_count DESC;


-- =========================================================
-- 9. CASE in ORDER BY (Custom Sorting)
-- =========================================================

-- Custom sorting: Premium → Regular → Student
SELECT *
FROM customers
ORDER BY 
    CASE customer_segment
        WHEN 'Premium' THEN 1
        WHEN 'Regular' THEN 2
        WHEN 'Student' THEN 3
        ELSE 4
    END,
    last_name;


-- =========================================================
-- 10. Combining All Filtering Methods
-- =========================================================

-- Complex query with AND, OR, IN, BETWEEN, LIKE, CASE
SELECT 
    product_name,
    category,
    price,
    stock_quantity,
    CASE 
        WHEN price < 100 THEN 'Budget'
        WHEN price < 500 THEN 'Mid-Range'
        WHEN price < 1000 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_tier,
    CASE 
        WHEN stock_quantity = 0 THEN 'Out of Stock'
        WHEN stock_quantity < 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM products
WHERE category IN ('Electronics', 'Gaming')
  AND price BETWEEN 100 AND 1500
  AND (product_name LIKE '%Pro%' OR product_name LIKE '%Ultra%')
  AND stock_quantity > 0
ORDER BY 
    CASE 
        WHEN price < 100 THEN 1
        WHEN price < 500 THEN 2
        WHEN price < 1000 THEN 3
        ELSE 4
    END,
    price DESC;

-- =========================================================
-- 11. Customer Analysis with CASE
-- =========================================================

-- Customer segmentation by location and segment
SELECT 
    first_name,
    last_name,
    state,
    customer_segment,
    CASE 
        WHEN state IN ('CA', 'NY', 'TX') THEN 'Major State'
        ELSE 'Other State'
    END AS state_category,
    CASE 
        WHEN customer_segment = 'Premium' AND state IN ('CA', 'NY') THEN 'Gold'
        WHEN customer_segment = 'Premium' THEN 'Silver'
        WHEN customer_segment = 'Regular' THEN 'Bronze'
        ELSE 'Basic'
    END AS tier
FROM customers
WHERE customer_segment IN ('Premium', 'Regular')
  AND state IN ('CA', 'NY', 'TX', 'FL')
ORDER BY tier, last_name;


-- =========================================================
-- 12. Order Analysis with CASE
-- =========================================================

SELECT 
    order_id,
    order_date,
    total_amount,
    CASE 
        WHEN total_amount > 2000 THEN 'High Value'
        WHEN total_amount > 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_tier,
    CASE 
        WHEN order_status = 'Completed' THEN 'Done'
        WHEN order_status = 'Shipped' THEN 'On Its Way'
        WHEN order_status = 'Delivered' THEN 'Received'
        ELSE 'Pending'
    END AS status_description
FROM orders
WHERE order_status IN ('Completed', 'Shipped', 'Delivered')
  AND total_amount BETWEEN 500 AND 5000
ORDER BY total_amount DESC;
