WITH daily AS(
		SELECT 
			"date",
			store_id, 
			product_id, 
			SUM(units) AS units_sold
		FROM 
			sales
		GROUP BY 
			"date",
			store_id,
			product_id
		ORDER BY 
			"date", 
			store_id,
			product_id),
/* Used to calculate only the days that stores were open.*/
	days_open AS (
		SELECT 
			store_id, 
			COUNT(DISTINCT "date") AS num 
		FROM
			sales 
		GROUP BY 
			store_id),
/*The randomness of store open dates led to bad data when calculated grouped by 
	weeks. Daily averages multiplied by 7 is used as a replacement. */
	weekly AS (
		SELECT 
			daily.store_id AS store_id,
			product_id, 
			ROUND(((SUM(units_sold))/MAX(days_open.num)*7),2) AS avg_units
		FROM 
			daily
		INNER JOIN 
			days_open 
			ON
			daily.store_id = days_open.store_id
		GROUP BY
			daily.store_id,
			product_id
		ORDER BY 
			daily.store_id, 
			product_id),
/* If stock is less than average weekly units sold the store needs to order more. 
	To ensure stores are adequately stocked and to limit the number of deliveries, 
	stores reorder two weeks of inventory minus current stock or 5 units, whichever 
	is greater.*/ 
	order_amount AS(
		SELECT 
			inventory.store_id,
			inventory.product_id,
			CASE WHEN 
				SUM(stock_on_hand - weekly.avg_units) < 0 
				AND 
				SUM(weekly.avg_units - stock_on_hand) >= 5 
				THEN CEIL(SUM(weekly.avg_units * 2 - stock_on_hand))
				WHEN 
				SUM(stock_on_hand - weekly.avg_units) > 0
				THEN 0 
				ELSE 5 
			END AS num
		FROM
			inventory
		LEFT JOIN
			weekly
			ON
			inventory.store_id = weekly.store_id
			AND 
			inventory.product_id = weekly.product_id
		GROUP BY 
			inventory.store_id,
			inventory.product_id)
			
SELECT 
	store_name, 
	product_name,
	SUM(num) AS order_amount
FROM 
	inventory
INNER JOIN
	stores 
	ON
	inventory.store_id = stores.store_id
INNER JOIN 
	products 
	ON
	inventory.product_id = products.product_id
INNER JOIN
	order_amount
	ON
	inventory.store_id = order_amount.store_id
	AND
	inventory.product_id = order_amount.product_id
WHERE 
	stock_on_hand = 0
GROUP BY 
	store_name, 
	product_name
ORDER BY 
	store_name, 
	product_name;