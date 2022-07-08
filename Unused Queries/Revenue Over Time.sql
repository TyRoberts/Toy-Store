SELECT 
	EXTRACT(year FROM "date") AS "year",
	EXTRACT(month FROM "date") AS "month", 
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
	"month"
ORDER BY 
	"year",
	"month";