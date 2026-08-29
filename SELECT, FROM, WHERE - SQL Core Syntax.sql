--===============================================================================================================================================================================
--✅ 1. SELECT ALL COLUMNS

-- Select every column from the customers table
-- * means "all columns"
SELECT * 
FROM customers;

--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 2. SELECT SPECIFIC COLUMNS

-- Select only first_name, last_name, and email
-- This is faster and cleaner than SELECT *
SELECT first_name, last_name, email
FROM customers;
--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 3. SELECT WITH ALIASES (AS)

-- Rename columns in the output for better readability
SELECT 
    first_name AS "First Name",   -- Changes column header
    last_name AS "Last Name",
    email AS "Email Address"
FROM customers;
--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 4. SELECT WITH CALCULATIONS

-- Perform math on columns
SELECT 
    product_name,
    price,
    price * 0.10 AS "Tax (10%)",      -- Calculate 10% tax
    price + (price * 0.10) AS "Total"  -- Price + tax
FROM products;
--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 5. SELECT DISTINCT (Remove Duplicates)

-- Show only unique categories (no repeats)
SELECT DISTINCT category
FROM products;

-- Unique combinations of two columns
SELECT DISTINCT category, sub_category
FROM products;
--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 6. WHERE — FILTER ROWS

-- Show only Premium customers
--Equal To (=)
SELECT * 
FROM customers
WHERE customer_segment = 'Premium';

--Not Equal To (!= or <>)
-- Show all customers except Premium
SELECT * 
FROM customers
WHERE customer_segment != 'Premium';

--Greater Than (>)
-- Show products over $1000
SELECT * 
FROM products
WHERE price > 1000;

--Less Than (<)
--Show products under $100
SELECT * 
FROM products
WHERE price < 100;Less Than (<)

--Greater Than or Equal (>=)
-- Show orders of $2000 or more
SELECT * 
FROM orders
WHERE total_amount >= 2000;

--Less Than or Equal (<=)
-- Show products with 10 or fewer units
SELECT * 
FROM products
WHERE stock_quantity <= 10;
--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 7. WHERE WITH AND (All Conditions Must Be True)

-- Premium customers from California
SELECT * 
FROM customers
WHERE customer_segment = 'Premium'   -- Must be Premium
  AND state = 'CA';                 -- AND from California

-- Electronics products over $1000 in stock
SELECT * 
FROM products
WHERE category = 'Electronics'      -- Must be Electronics
  AND price > 1000                  -- AND expensive
  AND stock_quantity > 0;           -- AND in stock

--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 8. WHERE WITH OR (At Least One Condition True)

-- Customers from CA OR NY
SELECT * 
FROM customers
WHERE state = 'CA'    -- Either California
   OR state = 'NY';   -- OR New York

-- Products that are Electronics OR Gaming
SELECT * 
FROM products
WHERE category = 'Electronics'   -- Either Electronics
   OR category = 'Gaming';       -- OR Gaming

--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 9. WHERE WITH NOT (Reverse Condition)

-- Customers who are NOT Premium
SELECT * 
FROM customers
WHERE NOT customer_segment = 'Premium';

-- Products NOT in Electronics
SELECT * 
FROM products
WHERE NOT category = 'Electronics';

--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 10. WHERE WITH IN (Multiple Values)

-- Customers from CA, NY, or TX (cleaner than multiple ORs)
SELECT * 
FROM customers
WHERE state IN ('CA', 'NY', 'TX');

-- Products in Electronics or Gaming
SELECT * 
FROM products
WHERE category IN ('Electronics', 'Gaming');

--NOT IN (Exclude Values)
-- Customers NOT from CA or NY
SELECT * 
FROM customers
WHERE state NOT IN ('CA', 'NY');
--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 11. WHERE WITH BETWEEN (Range)

-- Products priced between $100 and $500
SELECT * 
FROM products
WHERE price BETWEEN 100 AND 500;   -- Includes 100 and 500

-- Orders from 2024
SELECT * 
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31';

-- NOT BETWEEN
SELECT * 
FROM products
WHERE price NOT BETWEEN 100 AND 500;
--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 12. WHERE WITH IS NULL / IS NOT NULL
-- Customers with missing phone numbers
SELECT * 
FROM customers
WHERE phone IS NULL;

-- Customers who have phone numbers
SELECT * 
FROM customers
WHERE phone IS NOT NULL;

--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 13. COMBINING SELECT, FROM, WHERE

-- Find Premium customers from CA or NY with Gmail
SELECT 
    first_name,
    last_name,
    email,
    state
FROM customers
WHERE customer_segment = 'Premium'      -- Premium only
  AND (state = 'CA' OR state = 'NY')    -- CA or NY
  AND email LIKE '%gmail.com';          -- Gmail only
--===============================================================================================================================================================================

--===============================================================================================================================================================================
--✅ 14. COMPLETE PRACTICE EXAMPLE

/*
   Query: Premium Customers Report
   Purpose: Show Premium customers from major states
   Author: Amber
*/
SELECT 
    customer_id AS "ID",                     -- Customer number
    first_name AS "First Name",              -- First name
    last_name AS "Last Name",                -- Last name
    email AS "Email",                        -- Email address
    state AS "State",                        -- State
    registration_date AS "Joined"            -- Registration date
FROM customers                               -- From customers table
WHERE customer_segment = 'Premium'           -- Only Premium
  AND state IN ('CA', 'NY', 'TX', 'FL')      -- Only these states
  AND registration_date >= '2024-01-01';     -- Registered in 2024+

--===============================================================================================================================================================================


