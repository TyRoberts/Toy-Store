SELECT 
	EXTRACT (year FROM "date") AS "year",
	EXTRACT (month FROM "date") AS "month",
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
	"year",
	"month", 
	CUBE(store_name,product_name)
ORDER BY 
	store_name,
	"year",
	"month",
	product_name;