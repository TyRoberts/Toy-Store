WITH category AS(
		SELECT 
			store_id, 
			product_category, 
			DATE_TRUNC('month', "date") AS "month", 
			SUM(units) AS totalUnits 
		FROM
			sales
		INNER JOIN 
			products
			ON
			sales.product_id = products.product_id
		GROUP BY 
			store_id, 
			product_category,
			"month"), 
	per_product AS(
		SELECT 
			store_id, 
			sales.product_id, 
			product_category, 
			DATE_TRUNC('month', "date") AS "month",
			SUM(units) AS totalUnits
		FROM 
			sales
		INNER JOIN 
			products 
			ON
			sales.product_id = products.product_id
		GROUP BY 
			store_id,
			sales.product_id,
			"month",
			product_category)
		
SELECT 
	store_name,
	TO_CHAR(per_product.month, 'MM-YYYY') AS "month",
	products.product_category, 
	product_name,
	per_product.totalUnits AS units_sold,
	ROUND(per_product.totalUnits * 100/category.totalUnits, 2) || '%' AS pct_of_category_total
FROM 
	per_product
INNER JOIN 
	category
	ON
	per_product.store_id = category.store_id 
	AND 
	per_product.month = category.month
	AND 
	per_product.product_category = category.product_category
INNER JOIN 
	stores 
	ON
	category.store_id = stores.store_id
INNER JOIN 
	products 
	ON
	per_product.product_id = products.product_id
ORDER BY 
	store_name, 
	"month", 
	products.product_category;
