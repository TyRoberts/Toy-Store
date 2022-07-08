SELECT
	store_name,
	product_name, 
	CAST(SUM(product_price * units) AS money) AS revenue
FROM
	sales
INNER JOIN 
	products
	ON 
	 sales.product_id = products.product_id
INNER JOIN 
	stores 
	ON 
	sales.store_id = stores.store_id
GROUP BY 
	store_name,
	product_name
ORDER BY 
	product_name,
	revenue DESC;