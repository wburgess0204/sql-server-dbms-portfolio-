-- ====================================================================
-- Student: Wesley Burgess
-- Course: Computer Science 303
-- Assignment: Assignment 2
-- Date: 28 August 2025
-- Target Engine: MySQL
-- Description: 3rd Normal Form (3NF) Relational Database Schema Creation
-- ====================================================================

/*
CONCEPTUAL BACKGROUND (FROM PROJECT ANALYSIS):
- Functional and Transitive dependencies are important to consider in database design 
  because they can have a negative impact on the database’s data integrity and efficiency 
  for business purposes. It’s crucial to understand and locate these data issues as they 
  will cause redundant, unnecessary data to be present in a database. 

- A functional dependency occurs when there is a direct relationship between a set of columns 
  in that one attribute determines another attribute. The Employee ID functions as the 
  primary key because all of the other columns in the table depend on it.

- A Transitive dependency occurs in a table when there is an indirect dependency between 
  non-key attributes, or a column doesn’t depend directly on the primary key. (e.g., Employee ID -> 
  Manager ID -> Department or Employee ID -> Zip Code -> City and State).

- Business Consequences: Redundant information and dependencies that are not properly managed 
  causes the database to suffer from redundancy and update anomalies as changes in a single place 
  must be repeated across multiple rows. For example, if an assistant manager’s name or department 
  changes, the database stores that information multiple times for every employee, and an inability 
  to update every instance could lead to inconsistent data.

- Normalization Status: The original table was in 2nd Normal Form (2NF) since it met 1NF rules 
  and each row had a unique Employee ID with no partial dependencies. However, it contained 
  transitive dependencies. This new design splits the data into separate tables to satisfy 3NF.
*/

-- Create zip codes table under company_information schema
-- Each zip code is unique and city and state are only dependent on zip code
-- Removes duplication where multiple employees in the same ZipCode duplicate City and State.
USE company_information;

CREATE TABLE zip_codes (
    zip_code CHAR(5) PRIMARY KEY,
    city VARCHAR(30) NOT NULL,
    state CHAR(2) NOT NULL
);


-- Create positions table under company_information schema to remove repeated salary information
-- Salary now only depends on the position as each position has a unique Position ID
-- Removes duplication where multiple employees in the same Position mean the duplication of Salary.
USE company_information;

CREATE TABLE positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL UNIQUE
);


-- Create Employee table under company_information schema with Employee ID as the primary key. 
-- It includes foreign keys for Position, Department, Manager, and Zip Code
-- Repeated information is removed by moving to separate tables that are linked
-- This table was dropped and revised to correct primary key and foreign key issues
USE company_information;

CREATE TABLE Employee (
    employee_ID INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(30),
    first_name VARCHAR(30),
    street_address VARCHAR(100),
    zip_code CHAR(5),
    position_ID INT,
    salary DECIMAL(10,2),
    department_id INT,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_ID),
    FOREIGN KEY (position_ID) REFERENCES positions(position_id),
    FOREIGN KEY (zip_code) REFERENCES zip_codes(zip_code)
);


-- Create Departments table under company_information schema remove transitive dependencies 
-- between Employee and Manager. Each Department has a unique Department ID
USE company_information;

CREATE TABLE departments (
    department_id   INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    manager_emp_id  INT,
    FOREIGN KEY (manager_emp_id) REFERENCES Employee(employee_ID)
);


-- Added department_id foreign key to Employee
ALTER TABLE Employee
ADD CONSTRAINT fk_addition
FOREIGN KEY (department_id) REFERENCES departments(department_id);

/*
WORKS CITED (FROM ORIGINAL ASSIGNMENT):
- Elmasri, Ramez, and Shamkant B. Navathe. Fundamentals of Database Systems. 7th ed., Pearson, 2016.
- Gibbs, Martin. "Third Normal Form in DBMS with Examples." Study.com, 8 April 2024.
- Odugbesan, Temitayo. "What is Normal Form in DBMS? - Types & Examples." Study.com, 3 January 2025.
*/
