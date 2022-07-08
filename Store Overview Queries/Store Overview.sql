WITH inv AS(
		SELECT
			store_id,
			SUM(stock_on_hand) AS "Inventory"
		FROM
			inventory
		GROUP BY 
			store_id),
	inv_cost AS(
		SELECT
			store_id,
			SUM(stock_on_hand * product_cost) AS "Inventory Cost"
		FROM
			inventory
		INNER JOIN
			products 
			ON
			inventory.product_id = products.product_id
		GROUP BY
			store_id)

SELECT
	store_name AS "Store Name",
	CAST(SUM(product_price * units) AS money) AS "Revenue",
	CAST(SUM(product_cost * units) AS money) AS "Cost of Goods Sold",
	CAST(SUM((product_price - product_cost) * units) AS money) AS "Profit",
	COUNT(sale_id) AS "Transactions",
	SUM(units) AS "Units Sold",
	"Inventory",
	CAST("Inventory Cost" AS money)
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
INNER JOIN
	inv
	ON
	sales.store_id = inv.store_id
INNER JOIN
	inv_cost
	ON
	sales.store_id = inv_cost.store_id
GROUP BY 
	store_name,
	"Inventory",
	"Inventory Cost"
ORDER BY 
	store_name;