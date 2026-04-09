
-- 1. Where are we losing leads BEFORE they become deals?(sales funnel)


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


-- 2. Employees with below average performance(sales funnel)

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
