WITH units AS(
		SELECT 
			store_name,
			product_name, 
			EXTRACT('month' FROM "date") AS "month",
			EXTRACT('year' FROM "date") AS "year", 
			SUM(units) AS total 
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
		GROUP BY 
			store_name, 
			product_name, 
			"month", 
			"year"),
	profit AS(
		SELECT 
			product_name, 
			SUM(product_price - product_cost) AS profit
		FROM 
			products
		GROUP BY 
			product_name)
			 
SELECT 
	"year",
	"month",
	store_name,
	units.product_name, 
	CAST((units.total * profit.profit) AS money) AS profit
FROM 
	units
INNER JOIN
	profit
	ON
	units.product_name = profit.product_name
ORDER BY
	"month", 
	"year", 
	store_name, 
	product_name;