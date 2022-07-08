SELECT 
	store_location,
	COUNT(*) AS num_of_stores 
FROM
	stores
GROUP BY 
	store_location
ORDER BY
	num_of_stores;