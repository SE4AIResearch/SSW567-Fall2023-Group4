SELECT min("#revisions") as Minimum, avg("#revisions") as Mean, max("#revisions") as Maximum FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%'));

SELECT
    (
        SELECT value
        FROM (
            SELECT "#revisions" AS value
            FROM QT_results AS main
            WHERE main."subject categories" LIKE 'refactor%'
                AND main."subject keywords" LIKE 'refactor%'
                AND main."description categories" LIKE 'refactor%'
                AND main."description keywords" LIKE 'refactor%'
                AND NOT EXISTS (
                    SELECT 1
                    FROM QT_results AS sub
                    WHERE sub.rowid = main.rowid
                    AND (
                        sub."subject" LIKE '%revert%'
                        OR sub."subject" LIKE '%deprecate%'
                        OR sub."description" LIKE '%revert%'
                        OR sub."description" LIKE '%deprecate%'
                    )
                )
            ORDER BY "#revisions"
        )
        LIMIT (SELECT COUNT(*) FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (
            SELECT 1
            FROM QT_results AS sub
            WHERE sub.rowid = main.rowid
            AND (
                sub."subject" LIKE '%revert%'
                OR sub."subject" LIKE '%deprecate%'
                OR sub."description" LIKE '%revert%'
                OR sub."description" LIKE '%deprecate%'
            )
        )) / 2
    ) AS Median;


WITH filtered_data AS (
SELECT "#revisions" FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%')))
SELECT MAX("#revisions") AS Q1 FROM (SELECT "#revisions", NTILE(4) OVER (ORDER BY "#revisions") 
AS quartile FROM filtered_data) AS quartile_data WHERE quartile = 1;

SELECT MAX("#revisions") AS Q3 FROM
(SELECT "#revisions", NTILE(4) OVER (ORDER BY "#revisions") AS quartile FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%'))) 
AS filtered_data WHERE quartile = 3;