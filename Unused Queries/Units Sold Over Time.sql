SELECT 
	DATE_PART('year',"date") AS "year",
	DATE_PART('month',"date") AS "month", 
	TO_CHAR(SUM(units),'FM9G999G999') AS units
FROM 
	sales
GROUP BY 
	"month",
	"year"
ORDER BY 
	"year",
	"month";