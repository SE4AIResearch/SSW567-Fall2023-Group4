SELECT min("#files") as Minimum, avg("#files") as Mean, max("#files") as Maximum FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%'));

SELECT
    (
        SELECT value
        FROM (
            SELECT "#files" AS value
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
            ORDER BY "#files"
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
SELECT "#files" FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%')))
SELECT MAX("#files") AS Q1 FROM (SELECT "#files", NTILE(4) OVER (ORDER BY "#files") 
AS quartile FROM filtered_data) AS quartile_data WHERE quartile = 1;

SELECT MAX("#files") AS Q3 FROM
(SELECT "#files", NTILE(4) OVER (ORDER BY "#files") AS quartile FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%'))) 
AS filtered_data WHERE quartile = 3;