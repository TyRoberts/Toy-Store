SELECT 
	DATE_PART('year',"date") AS "year",
	DATE_PART('quarter',"date") AS quarter, 
	DATE_PART('month',"date") AS "month", 
	TO_CHAR(SUM(units),'FM9G999G999') AS units
FROM 
	sales
GROUP BY 
	ROLLUP("year","quarter","month")
ORDER BY 
	"year",
	"month",
	"quarter";