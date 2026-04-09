-- 1. Retrieve all customers along with their city and country from the Address table

SELECT
	customerId, 
    city, 
    state
FROM Customer c
JOIN Address a
ON c.addressId = a.addressId;


-- 2.List all products along with their brand names.

SELECT 
	p.name, 
    brandname
FROM Product p
JOIN Brand b
ON p.brandId = b.brandId;

-- 3. Find the total number of customers in the database.

SELECT COUNT(*)
FROM Customer;

-- 4. Retrieve all orders placed in the last 30 days.

SELECT 
	orderId,
    OrderDate
FROM Orders
WHERE OrderDate >= (
	SELECT MAX(OrderDate) FROM Orders
)- INTERVAL 30 DAY;


-- 5. Show the total number of orders per customer.

SELECT
	customerId,
    COUNT(orderId)
FROM Orders
GROUP BY customerId;


-- 6. List all employees along with their department names.

SELECT 
	employeeId, 
    name, 
    departmentName
FROM Employee e
JOIN Departments d
ON e.departmentId = d.departmentId;

-- 7. Retrieve all deals that are currently in the 'won' stage.

SELECT 
	dealId,
    title
FROM Deal
WHERE stage = "won";

-- 8. Management wants to know which products are actually driving revenue (not just being sold).

SELECT
	p.productId,
    p.name,
    p.description,
    p.price,
    c.categoryName,
    b.brandName,
    SUM(od.Quantity * od.UnitPrice) AS total_revenue
FROM OrderDetail od
JOIN Product p
ON od.productId = p.productId
JOIN Category c
ON p.categoryId = c.categoryId
JOIN Brand b
ON p.brandId = b.brandId
GROUP BY 
	od.productId,
    p.name,
    p.description,
    p.price,
    c.categoryName,
    b.brandName;
    

-- 9. Top 3 customers by total spending.

SELECT 
	o.customerId,
    c.name,
    SUM(o.TotalAmount) AS Total_Spending
FROM Orders o
JOIN Customer c
ON o.customerId = c.customerId
GROUP BY 
	o.customerId,
    c.name
ORDER BY Total_Spending DESC LIMIT 3;

-- 10. Management wants to evaluate workload distribution across sales reps.

SELECT
	l.assigned_to,
    e.name,
    COUNT(l.leadId) AS Leads_Assigned
FROM Lead_ l
RIGHT JOIN Employee e
ON l.assigned_to = e.employeeId
GROUP BY 
		l.assigned_to,
        e.name;
        
        
-- 11. How effectively are leads turning into actual deals?

SELECT 
	(
		SELECT COUNT(leadId) 
        FROM Lead_
	) AS Total_Leads,
    
    (
		SELECT COUNT(DISTINCT leadId) 
        FROM Deal
        WHERE leadId IS NOT NULL
	) AS Converted_Leads,
    
    (
		    (
		SELECT COUNT(DISTINCT leadId) 
        FROM Deal
        WHERE leadId IS NOT NULL
	)  * 100 / 	(
		SELECT COUNT(leadId) 
        FROM Lead_
	)
	) AS Conversion_Rate;


-- 12. Monthly revenue trends from last year

SELECT
	DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
    SUM(TotalAmount) AS Revenue
FROM Orders
WHERE OrderDate >= (
	SELECT MAX(OrderDate)
    FROM Orders
) - INTERVAL 1 YEAR
GROUP BY Month
ORDER BY Month;

-- 13. Find customers who have placed more than 3 orders.

SELECT
	customerId,
    COUNT(orderId) AS Order_Count
FROM Orders
GROUP BY customerId
HAVING Order_Count >= 3;


-- 14. List employees who have not been assigned any deals.

SELECT
	e.employeeId,
    e.name
FROM Employee e
LEFT JOIN Deal d
ON e.employeeId = d.owner_id
WHERE d.owner_id IS NULL;

-- 15. Who is most engaged with customers/leads?

SELECT
	employeeId,
    COUNT(activityId) AS Activity_Count
FROM ActivityEmployees
GROUP BY employeeId
ORDER BY Activity_Count DESC LIMIT 1;

-- 16. Sales team wants full visibility of deal origin (lead source, status, etc.)

SELECT
	d.dealId,
    d.title,
    d.value,
    d.stage,
    d.expected_close_date,
    d.leadId,
    l.name,
    l.status,
    l.assigned_to,
    d.owner_id
FROM Deal d
JOIN Lead_ l
ON d.leadId = l.leadId;

-- 17. Calculate the average order value per customer.

SELECT
	customerId,
    ROUND(AVG(TotalAmount), 2) AS Average_OrderValue
FROM Orders
GROUP BY customerId;


-- 18. Find products that have never been ordered.

SELECT
	p.productid,
    p.name
FROM Product p
LEFT JOIN OrderDetail od
ON p.productId = od.productId
WHERE od.orderDetailId IS NULL;

-- 19. Who are the top-performing salespeople?

SELECT
	employeeId,
    DENSE_RANK() OVER(ORDER BY Deal_Value DESC) AS Employee_Rank
FROM (
	SELECT 
		e.employeeId,
        SUM(d.value) AS Deal_Value
	FROM Employee e
	JOIN Deal d
    ON e.employeeId = d.owner_id
    GROUP BY employeeId
) t;

-- 20. Identify the top 5 customers contributing to 80% of total revenue (Pareto analysis)

WITH customer_revenue AS (  -- revenue per customer
	SELECT
		o.customerId,
        c.name,
        SUM(o.TotalAmount) AS Revenue
	FROM Orders o
    JOIN Customer c
    ON o.customerId = c.customerId
    GROUP BY 
		o.customerId,
        c.name
),

cumulative_revenue AS (  -- Running revenue
	SELECT
		customerId,
        name,
        Revenue,
        SUM(Revenue) OVER(ORDER BY Revenue DESC) AS Cumulative_Revenue, -- Cumulative Revenue
		SUM(Revenue) OVER() AS Total_Revenue  -- Total revenue
	FROM customer_revenue
) 

SELECT
	DENSE_RANK() OVER(ORDER BY Revenue DESC) AS Contribution_Rank,
	customerId,
    name,
    Revenue,
    ROUND((Cumulative_Revenue / Total_Revenue) * 100, 2) AS Contribution_Percentage
FROM cumulative_revenue
WHERE (Cumulative_Revenue / Total_Revenue) <= 0.8
ORDER BY Revenue DESC LIMIT 5;


-- 21 A. Sales Funnel Analysis (funnel by employee)
-- Analyze the sales funnel: total leads, converted deals, won deals, and conversion percentages.

WITH lead_count AS (
	SELECT 
    assigned_to AS employeeId,
    COUNT(*) AS lc
    FROM Lead_
    GROUP BY employeeId
),
deal_count AS (
	SELECT 
    owner_id AS employeeId,
    COUNT(*) AS dc
    FROM Deal
    GROUP BY employeeId
),
won_deal_count AS (
	SELECT 
    owner_id AS employeeId,
    COUNT(*) AS wdc
    FROM Deal
    WHERE stage = "won"
    GROUP BY employeeId
)

SELECT 
	l.employeeId,
    COALESCE(l.lc, 0) AS leads,
    COALESCE(d.dc, 0) AS deals,
    COALESCE(wd.wdc, 0) AS won_deals,
    
    CASE
		WHEN COALESCE(l.lc, 0) = 0 THEN 0
        ELSE ROUND(COALESCE(d.dc, 0) * 100.0 / l.lc)
	END AS deal_rate,
    
    CASE
		WHEN COALESCE(d.dc, 0) = 0 THEN 0
        ELSE ROUND(COALESCE(wd.wdc, 0) * 100.0 / d.dc)
	END AS won_deal_rate
    
FROM lead_count l
LEFT JOIN deal_count d
ON l.employeeId = d.employeeId
LEFT JOIN won_deal_count wd
ON d.employeeId = wd.employeeId;    


-- 22. Where are we losing leads BEFORE they become deals?(sales funnel)


WITH lead_count AS (
	SELECT 
		assigned_to AS employeeId,
		COUNT(*) AS lc
    FROM Lead_
    GROUP BY employeeId
),

deal_count AS (
	SELECT
		owner_id AS employeeId,
        COUNT(*) AS dc
	FROM Deal
    GROUP BY employeeId
)

SELECT 
	l.employeeId,
    COALESCE(l.lc, 0) AS Leads,
    COALESCE(d.dc, 0) AS Deals,
    
	CASE
		WHEN COALESCE(l.lc, 0) = 0 THEN 0
        ELSE ROUND(COALESCE(d.dc, 0) * 100.0 / l.lc)
	END AS deal_rate

FROM lead_count l
LEFT  JOIN deal_count d	
ON l.employeeId = d.employeeId
ORDER BY deal_rate ASC;


-- 23. Employees with below average performance(sales funnel)

WITH lead_count AS (
	SELECT
		assigned_to AS employeeId,
		COUNT(*) AS lc
	FROM Lead_
	GROUP BY employeeId
),

deal_count AS (
	SELECT
		owner_id AS employeeId,
        COUNT(*) AS dc
	FROM Deal
	GROUP BY employeeId
),

funnel AS (
	SELECT
		l.employeeId,
        COALESCE(l.lc, 0) AS Leads,
        COALESCE(d.dc, 0) AS DealS,
        
        CASE
			WHEN COALESCE(l.lc, 0) = 0 THEN 0
            ELSE ROUND(COALESCE(d.dc, 0) * 100.0 / l.lc, 2)
		END AS deal_rate
	FROM lead_count l
    LEFT JOIN deal_count d
    ON l.employeeId = d.employeeId
)

SELECT *
FROM funnel
WHERE deal_rate < (
	SELECT AVG(deal_rate)
    FROM funnel
);



-- 24. Identify customers who have placed orders in at least 2 different months (repeat customers).[Customer Retention Analysis]

SELECT DISTINCT
	t.Id,
	t.customer,
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS Order_Date
FROM
	(SELECT
		o.customerId AS Id,
        c.name AS customer,
		COUNT(DISTINCT(DATE_FORMAT(o.OrderDate, '%Y-%m'))) AS DateCount
	FROM Orders o
	JOIN Customer c
	ON o.customerId = c.customerId
	GROUP BY 
		o.customerId,
		c.name
	HAVING DateCount >= 2) t
JOIN Orders o
ON o.customerId = t.Id;












		
    
