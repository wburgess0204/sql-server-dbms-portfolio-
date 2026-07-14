-- ====================================================================
-- Student: Wesley Burgess
-- Course: Computer Science 204
-- Assignment: Assignment 3
-- Date: 24 August 2025
-- Target Engine: SQL Server (T-SQL)
-- Description: Advanced SQL Functions, Schema Objects, and Business Logic
-- ====================================================================

-- ====================================================================
-- PART 1: Advanced SQL Functions
-- ====================================================================

-- 1. Total Sales by Category
-- This query uses the SUM aggregate function to find the total sales for each product category
SELECT Categories.category_name, SUM(Orders.order_amount) AS total_sales
FROM Orders
INNER JOIN Products ON Orders.product_id = Products.product_id
INNER JOIN Categories ON Products.category_id = Categories.category_id
GROUP BY Categories.category_name
ORDER BY total_sales;

-- 2. String Concatenation
-- This query concatenates the product name, supplier name, and phone into a single string 
SELECT product_name + ' (' + supplier_name + ', ' + phone + ') ' AS product_data
FROM Products
JOIN Suppliers ON Products.supplier_id = Suppliers.supplier_id;

-- 3. Temporal Grouping Analysis
-- This query uses date/time functions to group the total_orders from the Orders table in descending order
SELECT  
  YEAR(order_date) AS purchase_year,
  MONTH(order_date) AS purchase_month,
  COUNT(*) AS total_orders
FROM ORDERS
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY purchase_year DESC, purchase_month DESC;

-- 4. Dynamic Discount Subquery
-- This query uses a subquery with the MAX() function to locate the most expensive product.
-- The query then uses the UPDATE function to set a 20% discount for the most expensive product.
UPDATE Products
SET price = price * 0.8
WHERE price = (SELECT MAX(price) FROM Products);


-- ====================================================================
-- PART 2: Schema Objects and Business Logic
-- ====================================================================

-- 1. Database View Creation
-- This query creates a view of the top 5 best-selling products
CREATE VIEW top_five_products AS
SELECT TOP 5 product_id, SUM(quantity) AS top_selling
FROM Orders
GROUP BY product_id;
GO

-- 2. Stored Procedure Definition & Execution Sandbox
-- This query creates a stored procedure that accepts a product ID then returns the total quantity 
-- sold and revenue. The stored procedure is then executed.
CREATE PROCEDURE total_quantity_sold
   @product_id INT
AS
BEGIN
   SELECT 
     product_id, SUM(quantity) AS total_sold,
     SUM(order_amount) AS total_revenue
   FROM Orders
   WHERE product_id = @product_id
   GROUP BY product_id;
END;
GO

-- Execution of the defined stored procedure
EXEC total_quantity_sold @product_id = 101;
GO

-- 3. Data Integrity & Logging Trigger
-- This query creates a trigger that logs entries into the Inventory Audit table when a product’s 
-- quantity on hand (qoh) is updated. It also added a rule to stop negative values in the quantity on hand (qoh) field.
CREATE TRIGGER trg_qoh_update
ON Products
AFTER UPDATE
AS
BEGIN
    -- Ensuring qoh is not negative
    IF EXISTS (SELECT * FROM inserted WHERE qoh < 0)
    BEGIN
       RAISERROR('QOH cannot be negative.', 16, 1);
       ROLLBACK TRANSACTION;
       RETURN;
    END

    -- Logging the update
    INSERT INTO InventoryAudit (product_id, old_qoh, new_qoh, change_date)
    SELECT i.product_id, d.qoh, i.qoh, GETDATE()
    FROM inserted i
    JOIN deleted d ON i.product_id = d.product_id
    WHERE i.qoh <> d.qoh;
END;
GO

-- 4. ACID Transaction Control Block
-- This query creates a transaction block that is updating inventory and inserting a sales record
-- The transaction will roll back if any part of it fails
BEGIN TRY
    BEGIN TRANSACTION;

    -- Updating inventory quantity
    UPDATE inventory
    SET qoh = qoh - 1
    WHERE product_id = 1;

    -- Inserting into audit table
    INSERT INTO InventoryAudit (action, product_id, order_id, customer_id)
    VALUES ('UPDATE', 1, 1, 1);
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
END CATCH;
GO

-- 5. Performance Optimization Index
-- This query creates an index on the columns order_id, customer_id, and date.
-- This column was chosen because customer order history information with past transactions 
-- would be information that might need to be accessed often to analyze sales trends.
CREATE INDEX index_orders_customers_date
ON orders (customer_id, order_date);
GO
