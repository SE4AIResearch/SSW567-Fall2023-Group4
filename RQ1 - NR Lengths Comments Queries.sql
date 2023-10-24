SELECT min("len_messages") as Minimum, avg("len_messages") as Mean, max("len_messages") as Maximum FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) LIMIT 1174;

SELECT(SELECT value FROM (SELECT "len_messages" AS value FROM QT_results 
WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) ORDER BY "len_messages"
LIMIT 2 - (SELECT COUNT(*) FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) LIMIT 1174) % 2 
OFFSET (SELECT (COUNT(*) - 1) / 2 FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) LIMIT 1174)) 
AS subquery ) AS Median; 

WITH filtered_data AS (
SELECT "len_messages" FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) LIMIT 1174)
SELECT MAX("len_messages") AS Q1 FROM (SELECT "len_messages", NTILE(4) OVER (ORDER BY "len_messages") 
AS quartile FROM filtered_data) AS quartile_data WHERE quartile = 1;

SELECT MAX("len_messages") AS Q3 FROM
(SELECT "len_messages", NTILE(4) OVER (ORDER BY "len_messages") AS quartile FROM QT_results WHERE "index" NOT IN (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')))
AS filtered_data WHERE quartile = 3 LIMIT 1174;