SELECT 
	store_name, 
	store_location, 
	store_open_date, 
	DATE_PART('year', store_open_date) AS "year",
	COUNT(*) OVER(PARTITION BY DATE_PART('year', store_open_date)) AS number_of_stores
FROM 
	stores
ORDER BY 
	store_open_date;