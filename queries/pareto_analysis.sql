-- Identify the top 5 customers contributing to 80% of total revenue (Pareto analysis)

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
