SELECT min("churn") as Minimum, avg("churn") as Mean, max("churn") as Maximum FROM QT_results WHERE("subject categories" like 'refactor%' OR "subject keywords" like 'refactor%' OR "description categories" like 'refactor%' OR "description keywords" like 'refactor%') AND "index" not in (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%'));

SELECT(SELECT value FROM (SELECT "churn" AS value FROM QT_results 
WHERE("subject categories" like 'refactor%' OR "subject keywords" like 'refactor%' OR "description categories" like 'refactor%' OR "description keywords" like 'refactor%')  
AND "index" not in (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) ORDER BY "churn" 
LIMIT 2 - (SELECT COUNT(*) FROM QT_results WHERE("subject categories" like 'refactor%' OR "subject keywords" like 'refactor%' OR "description categories" like 'refactor%' OR "description keywords" like 'refactor%')  
AND "index" not in (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%'))) % 2 
OFFSET (SELECT (COUNT(*) - 1) / 2 FROM QT_results WHERE("subject categories" like 'refactor%' OR "subject keywords" like 'refactor%' OR "description categories" like 'refactor%' OR "description keywords" like 'refactor%')  
AND "index" not in (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')))) 
AS subquery ) AS Median; 

WITH filtered_data AS (
SELECT "churn" FROM QT_results WHERE("subject categories" like 'refactor%' OR "subject keywords" like 'refactor%' OR "description categories" like 'refactor%' OR "description keywords" like 'refactor%') 
and "index" not in (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')))
SELECT MAX("churn") AS Q1 FROM (SELECT "churn", NTILE(4) OVER (ORDER BY "churn") 
AS quartile FROM filtered_data) AS quartile_data WHERE quartile = 1;

SELECT MAX("churn") AS Q3 FROM
(SELECT "churn", NTILE(4) OVER (ORDER BY "churn") AS quartile FROM QT_results WHERE("subject categories" like 'refactor%' OR "subject keywords" like 'refactor%' OR "description categories" like 'refactor%' OR "description keywords" like 'refactor%') 
and "index" not in (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')))
AS filtered_data WHERE quartile = 3;