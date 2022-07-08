WITH store_units AS(
		SELECT
			store_id,
			SUM(units) AS total
		FROM
			sales
		GROUP BY 
			store_id)

--Store name is not selected because query is based on one store chosen in the WHERE statement.
--Aguascalientes 1 is used for example purposes throught Store Overview queries.
SELECT
	product_name AS "Product Name",
	SUM(units) AS "Units Sold",
	ROUND(SUM((units * 100) / total),2) || '%' AS "Percent of Store Total"
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
INNER JOIN
	store_units
	ON
	stores.store_id = store_units.store_id
WHERE 
	store_name = 'Maven Toys Aguascalientes 1' --Select store here
GROUP BY 
	product_name
ORDER BY 
	product_name;