SELECT 
	store_name, 
	product_name, 
	SUM(stock_on_hand) AS stock 
FROM 
	inventory
INNER JOIN 
	stores 
	ON
	inventory.store_id = stores.store_id
INNER JOIN 
	products 
	ON
	inventory.product_id = products.product_id
GROUP BY 
	store_name, 
	product_name
ORDER BY 
	store_name, 
	product_name;