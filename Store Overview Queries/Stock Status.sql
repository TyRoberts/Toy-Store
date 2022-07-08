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
			daily.store_id,
			product_id, 
			ROUND(((SUM(units_sold))/MAX(days_open.num)*7),2) AS avg_weekly_units
		FROM 
			daily
		INNER JOIN 
			days_open 
			ON
			daily.store_id = days_open.store_id
		GROUP BY
			daily.store_id,
			product_id),
/* If stock is less than average weekly units sold the store needs to order more. 
	To ensure stores are adequately stocked and to limit the number of deliveries, 
	stores reorder two weeks of inventory minus current stock or 5 units, whichever 
	is greater.*/ 
	order_amount AS(
		SELECT 
			weekly.store_id,
			weekly.product_id,
			CASE 
				WHEN CEIL(SUM(avg_weekly_units - stock_on_hand))>0 
				AND 
				CEIL(SUM(avg_weekly_units - stock_on_hand))< 5 
				THEN 5 
				WHEN CEIL(SUM(avg_weekly_units - stock_on_hand)) >= 5 
				THEN CEIL(SUM(avg_weekly_units * 2 - stock_on_hand))
				ELSE 0 
			END AS num
		FROM
			weekly
		INNER JOIN
			inventory
			ON
			weekly.store_id = inventory.store_id
			AND 
			weekly.product_id = inventory.product_id
		GROUP BY 
			weekly.store_id,
			weekly.product_id)

--Store name is not selected because query is based on one store chosen in the WHERE statement.
--Aguascalientes 1 is used for example purposes throught Store Overview queries.
SELECT
	product_name AS "Product Name",
	SUM(stock_on_hand) AS "Stock on Hand",
	ROUND(SUM(avg_weekly_units)) AS "Weekly Units Sold",
	SUM(num) AS "Order Amount"
FROM
	weekly
INNER JOIN
	stores 
	ON
	weekly.store_id = stores.store_id
INNER JOIN 
	products 
	ON
	weekly.product_id = products.product_id
INNER JOIN
	inventory 
	ON
	stores.store_id = inventory.store_id 
	AND 
	products.product_id = inventory.product_id
INNER JOIN
	order_amount
	ON
	inventory.store_id = order_amount.store_id
	AND
	inventory.product_id = order_amount.product_id
WHERE 
	store_name = 'Maven Toys Aguascalientes 1' -- Select store here
GROUP BY 
	product_name
ORDER BY 
	product_name;