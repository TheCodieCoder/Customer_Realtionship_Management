📊 _**CRM Analytics Project**_

**Overview**
This project simulates a real-world Customer Relationship Management (CRM) system and applies advanced SQL techniques to extract meaningful business insights.

The database includes modules for:

- Customer management
- Product & order transactions
- Sales pipeline (Leads → Deals)
- Employee & department structure
- Activity tracking

The goal of this project is to move beyond basic SQL queries and perform business-driven analytics similar to real industry use cases.

=> **Database Schema**

The project consists of the following tables:

- Customer, Address
- Product, Category, Brand
- Orders, OrderDetail
- Lead_, Deal
- Employee, Departments
- Activity, ActivityEmployees

Each table is populated with realistic sample data (100–300 rows)


**Key Business Analyses**

1. _Customer Retention Analysis_
Identified customers active in multiple months
Used date-based grouping to track repeat behavior
Helped understand customer loyalty

2. _Sales Funnel Analysis_
Tracked progression: Leads → Deals → Won Deals
Calculated conversion rates at each stage
Identified inefficiencies in the pipeline

3. _Drop-off Detection_
Measured where customers are lost in the funnel
Focused on Lead → Deal conversion
Highlighted underperforming areas

4. _Employee Performance Analysis_
Evaluated employees based on:
Leads handled
Deals generated
Deals won
Compared performance across team

5. _Benchmarking (Performance Comparison)_
Identified employees performing below average
Used subqueries to compute benchmarks
Enabled data-driven performance evaluation

6. _Revenue & Order Insights_
Aggregated revenue across customers and products
Identified high-value customers
Analyzed order patterns

**SQL Concepts Used**

This project demonstrates strong command over:

- _JOINs_ (multi-table joins)
- _Aggregations_ (SUM, COUNT, AVG)
- _GROUP BY & HAVING_
- _Subqueries_ (correlated & nested)
- _CTEs_ (WITH clause)
- _Date functions_ (DATE_FORMAT, CURDATE, INTERVAL)
- _Conditional logic_ (CASE, COALESCE)

**Key Learnings**
- Learned to translate business problems into SQL queries
- Understood importance of data grouping levels
- Built intuition for real-world analytics workflows
- Improved ability to debug SQL errors and optimize logic

**Future Improvements**
- Add Python (Pandas) for analysis
- Build dashboards (Power BI / Tableau)
- Implement window functions for deeper insights
- Perform cohort analysis

**ER Diagram Color Coding**

Here’s the clean breakdown of what each color represents in your ER diagram:

🟢 Green:	Product Management (Inventory side):	_Category, Brand, Product_

🔴 Red:	Order Management (Sales side):	_Orders, OrderDetail, Customer_

🟣 Purple: Activity / Interaction Tracking (CRM actions): 	_Activity_

🟡 Yellow: 	Sales Pipeline / CRM (Leads & Deals):	_Lead, Deal, Address_

🔵 Blue: 	Organization / Internal Structure:	_Employee, Departments, ActivityEmployees_

⚪ White / Grey: 	Relationships / Connectors	Foreign key links between tables

This project reflects my transition from writing SQL queries to performing real-world business analytics using SQL.


**Author**

Misbah Ur Rahman
