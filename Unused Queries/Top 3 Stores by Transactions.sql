WITH transactions AS (
		SELECT 
			store_name,
			DATE_TRUNC('month', "date") AS "month",
			COUNT(sale_id) AS total 
		FROM 
			sales 
		INNER JOIN 
			stores 
			ON
			sales.store_id = stores.store_id
		GROUP BY 
			store_name,
			"month"),
	"rank" AS(
		SELECT 
		store_name,
		SUM(total) AS total_transactions,
		RANK() OVER(ORDER BY SUM(total) DESC)
	FROM 
		transactions
	GROUP BY 
		store_name)

SELECT 
	transactions.store_name, 
	TO_CHAR("month", 'Mon-YY') AS "month", 
	total
FROM
	"rank"
INNER JOIN
	transactions
	ON
	"rank".store_name = transactions.store_name
WHERE
	rank <=3
ORDER BY 
	transactions.store_name,
	transactions.month, 
	rank;