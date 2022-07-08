WITH store_profits AS(
		SELECT
			store_id,
			SUM((product_price - product_cost) * units) AS store_profit
		FROM
			sales
		INNER JOIN
			products
			ON
			sales.product_id = products.product_id
		GROUP BY 
			store_id)

--Store name is not selected because query is based on one store chosen in the WHERE statement.
--Aguascalientes 1 is used for example purposes throught Store Overview queries.
SELECT 
	product_name AS "Product Name",
	CAST(SUM((product_price - product_cost) * units) AS money) AS "Profit",
	ROUND(SUM(((product_price - product_cost) * units * 100)/
			  store_profit),2) || '%' AS "Percent of Store Profit"
FROM
	sales
INNER JOIN
	stores
	ON
	sales.store_id = stores.store_id
INNER JOIN
	products
	ON
	sales.product_id = products.product_id
INNER JOIN
	store_profits
	ON
	stores.store_id = store_profits.store_id
WHERE 
	store_name = 'Maven Toys Aguascalientes 1' --Select store here
GROUP BY 
	product_name
ORDER BY 
	product_name;