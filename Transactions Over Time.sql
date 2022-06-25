SELECT 
	DATE_PART('year', "date") AS "year",
	DATE_PART('month',"date") AS "month",
	TO_CHAR(COUNT(*),'FM99G999') AS transactions 
FROM 
	sales
GROUP BY 
	"month",
	"year"
ORDER BY 
	"year",
	"month";