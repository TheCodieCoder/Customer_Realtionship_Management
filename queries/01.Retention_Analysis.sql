-- Identify customers who have placed orders in at least 2 different months (repeat customers).[Customer Retention Analysis]

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
