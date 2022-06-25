SELECT 
	CASE WHEN 
		product_name IS NULL 
		THEN 'All' 
		ELSE product_name 
	END,
	SUM(stock_on_hand) AS stock 
FROM 
	inventory
INNER JOIN 
	products 
	ON
	inventory.product_id = products.product_id
GROUP BY 
	ROLLUP(product_name)
ORDER BY 
	stock DESC;