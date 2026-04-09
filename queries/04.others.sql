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
