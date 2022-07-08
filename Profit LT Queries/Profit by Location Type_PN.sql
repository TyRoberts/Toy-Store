SELECT
	"Product",
	"Airport",
	"Commercial",
	"Downtown",
	"Residential"
FROM crosstab(
	$$ SELECT
		product_name,
		store_location,
		CAST(SUM(units *(product_price - product_cost)) AS money)
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
		product_name
	ORDER BY 
		product_name,
		store_location
		 $$,
	$$ VALUES
		('Airport'::text),
		('Commercial'::text),
		('Downtown'::text),
		('Residential'::text) $$
) AS profit (
		"Product" text,
		"Airport" money,
		"Commercial" money,
		"Downtown" money,
		"Residential" money);