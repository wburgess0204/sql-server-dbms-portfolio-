-- ====================================================================
-- Student: Wesley Burgess
-- Course: Computer Science 303
-- Assignment: Assignment 1
-- Date: 24 August 2025
-- Target Engine: MySQL / SQL Server Compatible
-- Description: Schema Creation, Table Alterations, and Relational Queries
-- Note: This script was validated and executed in SQL Server Management Studio (SSMS)
-- ====================================================================

-- ====================================================================
-- PROMPT 1: Create the Schema/Database
-- ====================================================================
CREATE DATABASE IF NOT EXISTS finalproject;
USE finalproject;


-- ====================================================================
-- PROMPT 2: Create Tables
-- ====================================================================

-- Created users Table
CREATE TABLE users (
  userid INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  username VARCHAR(100),
  address VARCHAR(150),
  city VARCHAR(100),
  state CHAR(2),
  zip VARCHAR(10)
);

-- Created locations Table
CREATE TABLE locations (
  itemid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  type INT,
  description VARCHAR(200),
  lng REAL,
  lat REAL
);

-- Created photograph Table
CREATE TABLE photograph (
  photoid INT,
  locationid INT
);


-- ====================================================================
-- PROMPT 3: Alter Tables
-- ====================================================================
-- Modifying fields to enforce strict NULL/NOT NULL constraints

ALTER TABLE locations
MODIFY type INT NOT NULL,
MODIFY description VARCHAR(200) NOT NULL,
MODIFY lng REAL NOT NULL,
MODIFY lat REAL NOT NULL;

ALTER TABLE users
MODIFY name VARCHAR(100) NOT NULL,
MODIFY username VARCHAR(20) NOT NULL;

ALTER TABLE photograph
MODIFY photoid INT NOT NULL,
MODIFY locationid INT NOT NULL;


-- ====================================================================
-- PROMPT 4: Create Index
-- ====================================================================
-- Implementing unique indexes to optimize performance and enforce unique identifiers

CREATE UNIQUE INDEX id ON users (userid);
CREATE UNIQUE INDEX photo_index ON photograph (photoid);


-- ====================================================================
-- PROMPT 5: Enter Data & Validate
-- ====================================================================

INSERT INTO users (name, username, address, city, state, zip) VALUES
('Bonnie Buntcake', 'bbunt', '6709 Wonder Street', 'Wonderbread', 'OH', 46105),
('Sam Smarf', 'ssmarf', '356 A Street', 'Beefy', 'PA', 19943),
('Wendy Grog', 'wgrog', '900 Star Street', 'Mary', 'MD', 21340),
('Joe Jogger', 'jjogger', '183713 N North Street', 'Norther', 'WV', 51423);

-- Verification Query (Validated via SSMS output screenshot)
SELECT * FROM users;


-- ====================================================================
-- PROMPT 6: Count Rows
-- ====================================================================
SELECT count(*) from users;


-- ====================================================================
-- PROMPT 7: Add Column
-- ====================================================================
ALTER TABLE photograph
ADD COLUMN userid INT AFTER locationid;


-- ====================================================================
-- PROMPT 8: Issue with New Column (Technical Analysis)
-- ====================================================================
/*
  CRITICAL DATA INTEGRITY OBSERVATION:
  The newly added column 'userid' in the 'photograph' table allows nullable data. 
  We must modify this column to make sure that it does not accept null, or empty, data. 
  If we do not update the column, data issues could arise if empty userid information is 
  added to the table. This increases the size of the table and slows down queries, which 
  could cause the database to be less efficient. 
  
  Also, and more importantly, missing and incomplete information will cause issues with 
  data reliability and integrity, as photographs could be saved without being connected to 
  a specific user. Therefore, a modification to make the userid column NOT NULL is needed 
  to prevent empty or missing data from being inserted in the future so correct relationships 
  between photographs and users can be maintained. This ensures referential integrity between 
  photographs and users, which is an important part of maintaining database consistency.
*/


-- ====================================================================
-- PROMPT 9: Location and Photograph Table Updates
-- ====================================================================

INSERT INTO locations (type, description, lng, lat) VALUES
(1, 'Independence Hall', 794.35, 651.43),
(2, '6709 Wonder Street', 323.41, 412.22),
(1, 'Sunrise', 221.45, 132.43),
(2, '356 A Street', 123.32, 222.43),
(1, 'Mountains', 34.12, 87.99),
(2, '900 Star Street', 1071.9, 206.45),
(1, 'Moonrise', 816.2, 111.2),
(2, '183714 N North Street', 176.11, 11.176);

INSERT INTO photograph (photoid, locationid, userid) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 6, 3),
(4, 8, 4);


-- ====================================================================
-- PROMPT 10: Base Users Query
-- ====================================================================
SELECT name FROM users;


-- ====================================================================
-- PROMPT 11: Who's Taking Pictures?
-- ====================================================================
-- Relational join to map users to their photograph logs
-- Updated to explicit INNER JOIN syntax to improve readability 
-- and follow modern SQL best practices (avoiding implicit comma joins)
SELECT users.name 
FROM users
INNER JOIN photograph ON users.userid = photograph.userid;


-- ====================================================================
-- PROMPT 12: Unique Names
-- ====================================================================
-- Utilizing DISTINCT to remove duplicate rows in user search outputs
-- Updated to explicit INNER JOIN syntax to improve readability 
-- and follow modern SQL best practices (avoiding implicit comma joins).
SELECT DISTINCT users.name 
FROM users
INNER JOIN photograph ON users.userid = photograph.userid;
