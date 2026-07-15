-- ====================================================================
-- Student: Wesley Burgess
-- Course: Computer Science 204
-- Assignment: Assignment 1
-- Date: 17 August 2025
-- Target Engine: Standard SQL / SQL Server Compatible
-- Description: Database Design: Normalization vs. Denormalization & Schema Implementation
-- ====================================================================

/*
DESIGN ANALYSIS (FROM PROJECT SUBMISSION):

1. Normalization (1NF, 2NF, 3NF):
   - 1st Normal Form: Met by identifying columns where data might be repeated 
     and splitting that information into separate tables. This ensures the information 
     is organized and there are no duplicated groups of data.
   - 2nd Normal Form: Met because there are no partial dependencies between tables. 
     All non-key columns depend on the whole primary key. This is completed by separating 
     information into their own tables and connecting them with foreign keys (e.g., supplier_id 
     referenced in Products; product_id referenced in Orders).
   - 3rd Normal Form: Met because the diagram has no transitive dependencies (non-key columns 
     depending on other non-key columns). For example, unit_price and order_date are stored 
     in separate tables because the price of a product can change depending on the order.

2. Benefits of Normalization & Cardinality:
   - Normalization reduces repeated information and unnecessary joins, structuring the database 
     in a logical, organized, accurate, and efficient way.
   - Cardinality considerations support real business processes: One supplier can provide many products, 
     but each product comes from one supplier. One customer can place many orders, but each order 
     belongs to only one customer. These correct one-to-many relationships result in a consistent schema.

3. Denormalization Trade-offs:
   - Combining tables back together (adding duplicate columns) can simplify queries and improve performance 
     in systems with massive datasets where query speeds are slow. However, it introduces duplicate data, 
     reduces consistency, makes error correction difficult, and creates a more complicated system.
*/

-- ====================================================================
-- Part 2: SQL Implementation
-- ====================================================================

-- 1. Create Lookup Tables
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

INSERT INTO Categories (category_id, category_name) VALUES 
(1, 'Books'),  
(2, 'Laptops'),
(3, 'T-Shirts'),
(4, 'Bicycles'),
(5, 'Furniture');

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL
);

INSERT INTO Suppliers (supplier_id, supplier_name) VALUES 
(1, 'Supplier 1'),  
(2, 'Supplier 2'),
(3, 'Supplier 3'),
(4, 'Supplier 4'),
(5, 'Supplier 5');


-- 2. Create Core Relational Tables with Foreign Keys
-- Enforces referential integrity links back to Categories and Suppliers
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    supplier_id INT,
    unit_price DECIMAL(8,2),
    qoh INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

INSERT INTO Products (product_id, product_name, category_id, supplier_id, unit_price, qoh) VALUES 
(1, 'Harry Potter: Chamber of Secrets', 1, 1, 12, 800),  
(2, 'Toshiba Laptop', 2, 2, 500, 100),
(3, 'Minecraft T-Shirt', 3, 3, 12, 900),
(4, 'Huffy Bicycle', 4, 4, 350, 300),
(5, 'Ashley Furniture Couch', 5, 5, 900, 50);

-- Update Action
UPDATE Products
SET unit_price = 1000
WHERE product_id = 5;


-- 3. Create Transaction-focused Table
-- Establishes the relationship linking customers, orders, and products
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_amount DECIMAL(8,2),
    order_date DATE,
    order_time TIME,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_amount, order_date, order_time) VALUES 
(1, 150, 1, 20, 240, '2025-08-16', '14:38:00'),  
(2, 151, 2, 50, 25000, '2025-08-16', '14:40:00'),  
(3, 152, 3, 80, 960, '2025-08-16', '14:45:00'),  
(4, 153, 4, 90, 31500, '2025-08-16', '14:48:00'),  
(5, 154, 5, 3, 2700, '2025-08-16', '14:50:00');  

-- Delete Action
DELETE FROM Orders
WHERE order_id = 1;
