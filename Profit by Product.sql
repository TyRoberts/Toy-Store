SELECT 
	CASE WHEN
		product_category IS NULL 
		THEN 'All'
		ELSE product_category 
	END,
	CASE WHEN 
		product_name IS NULL THEN 'All'
		ELSE product_name 
	END,
	ROUND(AVG(product_price - product_cost),2) AS avg_profit
FROM
	products
GROUP BY 
	product_category,
	ROLLUP(product_name)
ORDER BY 
	product_category,
	SUM(product_price - product_cost) DESC;
