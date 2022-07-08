SELECT 
	CASE WHEN 
		store_city IS NULL 
		THEN 'Total'
		ELSE store_city 
	END,
	COUNT(*) AS num_of_stores 
FROM 
	stores
GROUP BY 
	ROLLUP(store_city)
ORDER BY 
	num_of_stores DESC,
	store_city;