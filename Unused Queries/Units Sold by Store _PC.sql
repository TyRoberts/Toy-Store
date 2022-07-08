WITH per_store AS(
		SELECT 
			store_id,
			SUM(units) AS total_units 
		FROM 
			sales
		GROUP BY 
			store_id),
	category AS(
		SELECT 
			store_id, 
			product_category, 
			SUM(units) AS total_units 
		FROM 
			sales
		INNER JOIN 
			products
			ON
			sales.product_id = products.product_id
		GROUP BY
			store_id, 
			product_category)
	
SELECT 
	store_name, 
	product_category, 
	category.total_units AS units_sold,
	ROUND(category.total_units * 100/per_store.total_units, 2) || '%' AS pct_of_store_total
FROM 
	category
INNER JOIN 
	per_store
	ON
	category.store_id = per_store.store_id 
INNER JOIN 
	stores 
	ON
	category.store_id = stores.store_id
ORDER BY 
	store_name, 
	pct_of_store_total DESC;