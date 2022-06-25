WITH transactions AS (
		SELECT 
			store_id, 
			DATE_PART('quarter', "date") AS "quarter", 
			DATE_PART('year', "date") AS "year",
			COUNT(sale_id) AS total 
		FROM 
			sales
		GROUP BY 
			store_id,
			"quarter", 
			"year"),
	overall AS (
		SELECT
			DATE_PART('quarter',"date") AS "quarter", 
			DATE_PART('year',"date") AS "year",
			COUNT(DISTINCT sale_id)/COUNT(DISTINCT store_id) AS avgTransactions 
		FROM 
			sales
		GROUP BY 
			"year", 
			"quarter"),
	location_type AS (
		SELECT 
			store_location, 
			DATE_PART('quarter', "date") AS "quarter", 
			DATE_PART('year', "date") AS "year",
			COUNT(DISTINCT sale_id)/COUNT(DISTINCT sales.store_id) AS avgTransactions 
		FROM 
			sales
		INNER JOIN 
			stores ON
			sales.store_id = stores.store_id
		GROUP BY 
			store_location, 
			"year", 
			"quarter")

SELECT 
	stores.store_location,
	store_name, 
	overall.year,
	overall.quarter, 
	transactions.total AS total_transactions,
	overall.avgTransactions AS overall_avg_transactions, 
	SUM(total - overall.avgTransactions) 
		OVER (PARTITION BY store_name, overall.year, overall.quarter) AS dif_from_overall_avg,
	location_type.avgTransactions AS location_type_avg,
	SUM(total - location_type.avgTransactions)
		OVER (PARTITION BY stores.store_name, overall.year, overall.quarter) AS dif_from_loctype_avg
FROM
	transactions
INNER JOIN 
	overall 
	ON
	transactions.quarter = overall.quarter
	AND
	transactions.year = overall.year
INNER JOIN 
	stores 
	ON
	transactions.store_id = stores.store_id
INNER JOIN 
	location_type 
	ON
	stores.store_location = location_type.store_location 
	AND 
	overall.year = location_type.year
	AND 
	overall.quarter = location_type.quarter
ORDER BY 
	"year", 
	"quarter", 
	stores.store_location, 
	total_transactions DESC;
