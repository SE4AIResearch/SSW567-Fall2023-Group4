SELECT min("#messages") as Minimum, avg("#messages") as Mean, max("#messages") as Maximum FROM stratified_nonrefactor_sampled_data WHERE "index" NOT IN (SELECT "index" FROM stratified_nonrefactor_sampled_data WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) ;

SELECT(SELECT value FROM (SELECT "#messages" AS value FROM stratified_nonrefactor_sampled_data 
WHERE "index" NOT IN (SELECT "index" FROM stratified_nonrefactor_sampled_data WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) ORDER BY "#messages"
LIMIT 2 - (SELECT COUNT(*) FROM stratified_nonrefactor_sampled_data WHERE "index" NOT IN (SELECT "index" FROM stratified_nonrefactor_sampled_data WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) ) % 2 
OFFSET (SELECT (COUNT(*) - 1) / 2 FROM stratified_nonrefactor_sampled_data WHERE "index" NOT IN (SELECT "index" FROM stratified_nonrefactor_sampled_data WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) )) 
AS subquery ) AS Median; 

WITH filtered_data AS (
SELECT "#messages" FROM stratified_nonrefactor_sampled_data WHERE "index" NOT IN (SELECT "index" FROM stratified_nonrefactor_sampled_data WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')) )
SELECT MAX("#messages") AS Q1 FROM (SELECT "#messages", NTILE(4) OVER (ORDER BY "#messages") 
AS quartile FROM filtered_data) AS quartile_data WHERE quartile = 1;

SELECT MAX("#messages") AS Q3 FROM
(SELECT "#messages", NTILE(4) OVER (ORDER BY "#messages") AS quartile FROM stratified_nonrefactor_sampled_data WHERE "index" NOT IN (SELECT "index" FROM stratified_nonrefactor_sampled_data WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%')))
AS filtered_data WHERE quartile = 3 ;