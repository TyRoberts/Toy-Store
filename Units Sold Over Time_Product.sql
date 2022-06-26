WITH avg_units AS(
		SELECT 
			DATE_PART('month', "date") AS "month",
			DATE_PART('year', "date") AS "year",
			SUM(units)/COUNT(DISTINCT product_id) AS average
		FROM 
			sales
		GROUP BY 
			"month", 
			"year"),
	by_product AS(
		SELECT
			product_name, 
			DATE_PART('month', "date") AS "month",
			DATE_PART('year', sales.date) AS "year",
			SUM(units) as units
		FROM 
			sales
		INNER JOIN 
			products 
			ON
			sales.product_id = products.product_id
		GROUP BY 
			product_name, 
			"month",
			"year")
		
SELECT 
	avg_units.year,
	avg_units.month,
	product_name, 
	by_product.units,
	CASE WHEN 
		avg_units.average > by_product.units 
		THEN 'Below Average'
		WHEN 
		avg_units.average = by_product.units
		THEN 'Average'
		ELSE 'Above Aveage' 
	END AS units_sold_comparison
FROM 
	by_product
INNER JOIN
	avg_units 
	ON
	by_product.month = avg_units.month 
	AND 
	by_product.year = avg_units.year
ORDER BY 
	product_name, 
	"year", 
	"month";