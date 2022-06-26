WITH units AS(
		SELECT 
			products.product_name AS product_name, 
			store_location, 
			product_category,  
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
			store_location, 
			product_category, 
			products.product_name),
	profit AS(
		SELECT 
			products.product_name AS product_name, 
			SUM(product_price - product_cost) AS profit
		FROM 
			products
		GROUP BY 
			products.product_name)
			 
SELECT 
	units.store_location, 
	units.product_name, 
	CAST((units.total * profit.profit) AS money) AS profit
FROM 
	units
INNER JOIN 
	profit 
	ON
	units.product_name = profit.product_name
ORDER BY 
	store_location,
	units.product_name;