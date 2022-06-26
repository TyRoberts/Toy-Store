WITH units AS(
		SELECT 
			sales.product_id AS product_id,
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
			sales.product_id),
	profit AS(
		SELECT 
			product_id,
			SUM(product_price - product_cost) AS profit
		FROM 
			products
		GROUP BY
			product_id)
			 
SELECT 
	DISTINCT store_location, 
	product_category, 
	CAST(
		SUM(units.total* profit.profit) 
		OVER (PARTITION BY store_location, product_category) 
	AS money) AS total_profit
FROM 
	units
INNER JOIN 
	profit 
	ON
	units.product_id = profit.product_id
ORDER BY 
	store_location, 
	product_category;