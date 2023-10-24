SELECT * FROM QT_results WHERE ("subject categories" like 'refactor%' OR "subject keywords" like 'refactor%' OR "description categories" like 'refactor%' OR "description keywords" like 'refactor%') ORDER BY "#messages" DESC;
SELECT * FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%') ORDER BY "#messages" DESC;

SELECT * FROM QT_results WHERE("subject categories" like 'refactor%' OR "subject keywords" like 'refactor%' OR "description categories" like 'refactor%' OR "description keywords" like 'refactor%') 
and "index" not in (SELECT "index" FROM QT_results WHERE ("subject categories" like 'refactor%' AND "subject keywords" like 'refactor%' AND "description categories" like 'refactor%' AND "description keywords" like 'refactor%') ORDER BY "#messages" DESC)ORDER BY "#messages" DESC;


