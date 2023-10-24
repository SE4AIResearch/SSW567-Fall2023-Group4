SELECT min("#messages") as Minimum, avg("#messages") as Mean, max("#messages") as Maximum FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) LIMIT 1174;

SELECT(SELECT value FROM (SELECT "#messages" AS value FROM QT_results 
WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) ORDER BY "#messages"
LIMIT 2 - (SELECT COUNT(*) FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) LIMIT 1174) % 2 
OFFSET (SELECT (COUNT(*) - 1) / 2 FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) LIMIT 1174)) 
AS subquery ) AS Median; 

WITH filtered_data AS (
SELECT "#messages" FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) LIMIT 1174)
SELECT MAX("#messages") AS Q1 FROM (SELECT "#messages", NTILE(4) OVER (ORDER BY "#messages") 
AS quartile FROM filtered_data) AS quartile_data WHERE quartile = 1;

SELECT MAX("#messages") AS Q3 FROM
(SELECT "#messages", NTILE(4) OVER (ORDER BY "#messages") AS quartile FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')))
AS filtered_data WHERE quartile = 3 LIMIT 1174;