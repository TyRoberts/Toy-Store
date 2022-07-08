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

--Store name is not selected because query is based on one store chosen in the WHERE statement.
-- Aguascalientes 1 is used for example purposes throughout Store Overview queries.
SELECT
	product_name AS "Product Name", 
	CAST(SUM(product_cost * stock_on_hand) AS money) AS "Inventory Cost",
	ROUND(SUM((product_cost * stock_on_hand *100) / 
			  inventory_cost), 2) || '%' AS "Percent of Store Inventory Cost"
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
WHERE store_name = 'Maven Toys Aguascalientes 1'--Select store here
GROUP BY 
	product_name
ORDER BY
	product_name;