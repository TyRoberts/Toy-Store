SELECT 
	CASE WHEN 
		product_category IS NULL 
		THEN 'Total'
		ELSE product_category 
	END, 
	COUNT(*) AS num_of_products 
FROM 
	products
GROUP BY 
	ROLLUP(product_category)
ORDER BY 
	num_of_products DESC;