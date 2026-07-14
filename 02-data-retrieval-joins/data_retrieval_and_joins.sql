-- ====================================================================
-- Student: Wesley Burgess
-- Course: Computer Science 204
-- Assignment: Assignment 2
-- Date: 19 August 2025
-- Target Engine: Standard SQL / T-SQL compatible
-- Description: SQL Queries - Data Retrieval and Joins
-- ====================================================================

-- ====================================================================
-- PART 1: Data Retrieval from a Single Table
-- ====================================================================

-- 1. Product Attribute Selection
-- This query lists all the products, showing product name, category ID, price, and QOH.
SELECT product_name, category_id, unit_price, qoh
FROM Products;

-- 2. Out-of-Stock Filtering
-- This query selects all products in the table where the quantity (qoh or quantity on hand) is 
-- equal to zero.
SELECT product_id, product_name, qoh
FROM Products
WHERE qoh = 0;

-- 3. Range Filtering using BETWEEN
-- This query pulls all products with a unit price between $100 to $500 and excludes others.
SELECT product_name, category_id, unit_price, qoh
FROM Products
WHERE unit_price BETWEEN 100 AND 500;

-- 4. Aggregate Counts and Grouping
-- This query counts the number of products in each category, groups the results by category_id, 
-- and orders them in descending order by total_products. 
SELECT category_id, COUNT(*) AS total_products
FROM Products
GROUP BY category_id
ORDER BY total_products DESC;

-- 5. Average Calculation Aggregate
-- This query calculates the average product price in each category then groups the results by category_id.
SELECT category_id, AVG(unit_price) AS average_price
FROM Products
GROUP BY category_id;


-- ====================================================================
-- PART 2: Multi-Table Queries using Joins
-- ====================================================================

-- 1. Two-Table Inner Join
-- This query joins Products and Suppliers to list the product name, supplier name and contact 
-- details. It is completing an inner join with rows from two tables with a matching key. 
-- It is only returning products that have a matching supplier.
SELECT Products.product_name, Suppliers.supplier_name, Suppliers.phone, Suppliers.email
FROM Products
INNER JOIN Suppliers
ON Products.supplier_id = Suppliers.supplier_id;

-- 2. Three-Table Complex Inner Join
-- This query completes an Inner Join across three tables: Products, Categories, and Orders.
-- There is a matching key in each of the three tables, which is used to combine the rows from all
-- three tables.
SELECT Products.product_name, Categories.category_name, Orders.quantity, Orders.order_date
FROM Products
INNER JOIN Categories
ON Products.category_id = Categories.category_id
INNER JOIN Orders
ON Orders.product_id = Products.product_id;

-- 3. Left Outer Join for Unmatched Parent Records
-- This query completes a LEFT JOIN between Suppliers and Products to list all suppliers 
-- and their products, including suppliers with no products.
SELECT Suppliers.supplier_name, Products.product_name
FROM Suppliers
LEFT JOIN Products
ON Suppliers.supplier_id = Products.supplier_id;

-- 4. Simulated Full Outer Join (Set Union)
-- This query simulates a FULL OUTER JOIN to show all products and suppliers, including 
-- those that are not matched together between the two tables.
SELECT Products.product_name, Suppliers.supplier_name
FROM Products
LEFT JOIN Suppliers
ON Products.supplier_id = Suppliers.supplier_id
UNION
SELECT Products.product_name, Suppliers.supplier_name
FROM Products
RIGHT JOIN Suppliers
ON Products.supplier_id = Suppliers.supplier_id;

-- 5. Conditional Group Filtering with HAVING
-- This query completes a COUNT aggregation on the category_id column from Products.
-- It uses the GROUP BY to group the results by category_id, and filters the groups using the 
-- HAVING clause to show categories with more than 10 products available.
SELECT category_id, COUNT(*) AS total_products
FROM Products
GROUP BY category_id
HAVING COUNT(*) > 10;
