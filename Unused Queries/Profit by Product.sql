SELECT 
	product_name,
	ROUND(AVG(product_price - product_cost),2) AS avg_profit
FROM
	products
GROUP BY 
	product_name
ORDER BY
	avg_profit,
	product_name;