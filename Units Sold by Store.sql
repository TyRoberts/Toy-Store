WITH monthly AS(
		SELECT 
			DATE_TRUNC('month', "date") AS "month",
			SUM(units) AS total_units
		FROM 
			sales
		GROUP BY
			"month"),
	per_store AS(
		SELECT 
			store_id, 
			DATE_TRUNC('month', "date") AS "month",
			SUM(units) AS total_units
		FROM 
			sales
		GROUP BY 
			store_id, 
			"month")
	

SELECT 
	store_name, 
	TO_CHAR(per_store.month, 'MM-YYYY') AS "month", 
	per_store.total_units,
	ROUND(per_store.total_units * 100/monthly.total_units, 2) || '%' AS pct_of_total
FROM 
	per_store
INNER JOIN 
	stores 
	ON
	per_store.store_id = stores.store_id
INNER JOIN 
	monthly
	ON
	per_store.month = monthly.month
ORDER BY 
	store_name,
	"month";
