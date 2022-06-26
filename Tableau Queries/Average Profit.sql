SELECT 
	CASE WHEN 
		product_category IS NULL 
		THEN 'All'
		ELSE product_category 
	END,
	ROUND(AVG(product_price - product_cost),2) AS avg_profit
FROM 
	products
GROUP BY 
	ROLLUP(product_category)
ORDER BY 
	product_category;
/* Edit Test */
