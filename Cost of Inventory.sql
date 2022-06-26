WITH store_total AS(
		SELECT 
			store_id,
			SUM(product_cost * stock_on_hand) AS inventory_cost
		FROM
			inventory
		INNER JOIN
			products	
			ON
			inventory.product_id = products.product_id
		GROUP BY 
			store_id)

SELECT 
	store_name,
	product_name, 
	CAST(SUM(product_cost * stock_on_hand) AS money) AS inventory_cost,
	ROUND((SUM(product_cost * stock_on_hand) / SUM(store_total.inventory_cost)) * 100, 2) || '%' AS pct_of_store_inv_cost
FROM 
	products
INNER JOIN 
	inventory
	ON
	products.product_id = inventory.product_id
INNER JOIN 
	stores 
	ON
	inventory.store_id = stores.store_id
INNER JOIN
	store_total
	ON
	inventory.store_id = store_total.store_id
GROUP BY 
	product_name,
	store_name
ORDER BY 
	store_name,
	product_name;