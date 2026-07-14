# Relational Database Management & Design Portfolio

Welcome to my SQL portfolio. This repository contains a curated collection of relational database projects developed as part of my Computer Science classes for transfer credit to Western Governors University.

Using **Microsoft SQL Server Management Studio (SSMS)** and **MySQL**, these projects demonstrate foundational, university-level proficiencies in database architecture, data integrity enforcement, structural normalization, and server-side programmability.
---

## Repository Structure & Core Competencies

### 1. Database Architecture & Schema Normalization
* **Folder:** `/01-schema-design-normalization`
* **Key Concepts:** 1NF, 2NF, 3NF, Relational Cardinality, Anomaly Prevention.
* **Overview:** Demonstrates how to design relational database schemas from scratch, transform denormalized data into highly efficient **Third Normal Form (3NF)**, and resolve transitive dependencies.

### 2. Data Retrieval, Queries, & Joins
* **Folder:** `/02-data-retrieval-joins`
* **Key Concepts:** `INNER JOIN`, `LEFT/RIGHT JOIN`, Set Operations (`UNION`), Aggregate Functions (`COUNT`, `AVG`), and Conditional Filtering (`GROUP BY`, `HAVING`).
* **Overview:** Showcases multi-table joins, lookup queries, index creation, and data aggregation strategies used to extract clean, meaningful metrics from relational structures.

### 3. Advanced Programmability & Transactional Integrity
* **Folder:** `/03-advanced-programmability`
* **Key Concepts:** Stored Procedures, Automated Triggers, ACID Transactions, Error Handling (`TRY...CATCH`).
* **Overview:** Features advanced server-side programmability:
  * An **Automated Audit Trigger** designed to enforce business rules (preventing negative inventory) while writing operational logs.
  * A **Transaction Control Block** wrapped in structured error handling to ensure database changes commit atomically or safely roll back on failure.

---

## Technical Tooling
* **Database Management Systems:** Microsoft SQL Server (T-SQL), MySQL
* **Tools:** SQL Server Management Studio (SSMS), Command Line Interfaces
