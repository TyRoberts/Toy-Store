WITH per_store AS(
		SELECT 
			store_id,
			SUM(units) AS total_units
		FROM 
			sales
		GROUP BY 
			store_id)
	

SELECT 
	store_name,
	per_store.total_units AS total_units,
	ROUND(per_store.total_units * 100/SUM(total_units) OVER(), 2) || '%' AS pct_of_total
FROM 
	per_store
INNER JOIN 
	stores 
	ON
	per_store.store_id = stores.store_id
ORDER BY 
	store_name;