WITH transactions AS (
		SELECT 
			store_id, 
			DATE_TRUNC('month', "date") AS "month", 
			DATE_PART('year', "date") AS "year",
			COUNT(sale_id) AS totalTransactions 
		FROM 
			sales
		GROUP BY 
			store_id, 
			"month", 
			"year"),
	overall_avg AS (
		SELECT 
			DATE_TRUNC('month',"date") AS "month", 
			DATE_PART('year',"date") AS "year",
			COUNT(DISTINCT sale_id)/COUNT(DISTINCT store_id) AS avgTransactions 
		FROM 
			sales
		GROUP BY 
			"year", 
			"month"),
	location_type_avg AS (
		SELECT 
			store_location,
			DATE_TRUNC('month', "date") AS "month", 
			DATE_PART('year', "date") AS "year",
			COUNT(DISTINCT sale_id)/COUNT(DISTINCT sales.store_id) AS avgTransactions 
		FROM 
			sales
		INNER JOIN 
			stores 
			ON
			sales.store_id = stores.store_id
		GROUP BY 
			store_location, 
			"year", 
			"month")

SELECT 
	stores.store_location,
	store_name, 
	TO_CHAR(overall_avg.month, 'MM-YYYY') AS "month", 
	transactions.totalTransactions AS total_transactions,
	overall_avg.avgTransactions AS overall_avg,
	SUM(totalTransactions - overall_avg.avgTransactions) 
		OVER (PARTITION BY store_name, overall_avg.year, overall_avg.month) AS dif_from_overall_avg,
	location_type_avg.avgTransactions AS location_type_avg,
	SUM(totalTransactions - location_type_avg.avgTransactions)
		OVER (PARTITION BY stores.store_name, overall_avg.year, overall_avg.month) AS dif_from_location_type_avg
FROM 
	transactions
INNER JOIN 
	overall_avg 
	ON
	transactions.month = overall_avg.month
INNER JOIN
	stores 
	ON
	transactions.store_id = stores.store_id
INNER JOIN
	location_type_avg 
	ON
	stores.store_location = location_type_avg.store_location 
	AND
	overall_avg.month = location_type_avg.month
ORDER BY 
	overall_avg.month,
	overall_avg.year,
	stores.store_location, 
	total_transactions DESC;
