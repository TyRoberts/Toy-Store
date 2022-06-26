WITH transactions AS (
		SELECT 
			store_name,
			DATE_PART('quarter',"date") AS "quarter", 
			DATE_PART('year',"date") AS "year", 
			COUNT(sale_id) AS total 
		FROM 
			sales 
		INNER JOIN 
			stores 
			ON
			sales.store_id = stores.store_id
		GROUP BY 
			store_name,
			"quarter",
			"year"),
	"rank" AS(
		SELECT 
		store_name,
		"year", 
		"quarter", 
		SUM(total) AS total_transactions,
		RANK() OVER(PARTITION BY "quarter", "year" ORDER BY SUM(total) DESC)
	FROM 
		transactions
	GROUP BY 
		store_name,
		"year",
		"quarter")

SELECT 
	store_name, 
	"year", 
	"quarter", 
	total_transactions
FROM
	"rank"
WHERE
	rank <=3
ORDER BY 
	"year", 
	"quarter", 
	rank;