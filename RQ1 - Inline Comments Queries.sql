SELECT min("#inline_comments") as Minimum, avg("#inline_comments") as Mean, max("#inline_comments") as Maximum FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%'));

SELECT
    (
        SELECT value
        FROM (
            SELECT "#inline_comments" AS value
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
            ORDER BY "#inline_comments"
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
SELECT "#inline_comments" FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%')))
SELECT MAX("#inline_comments") AS Q1 FROM (SELECT "#inline_comments", NTILE(4) OVER (ORDER BY "#inline_comments") 
AS quartile FROM filtered_data) AS quartile_data WHERE quartile = 1;

SELECT MAX("#inline_comments") AS Q3 FROM
(SELECT "#inline_comments", NTILE(4) OVER (ORDER BY "#inline_comments") AS quartile FROM QT_results AS main WHERE main."subject categories" LIKE 'refactor%' AND main."subject keywords" LIKE 'refactor%' AND main."description categories" LIKE 'refactor%' AND main."description keywords" LIKE 'refactor%' AND NOT EXISTS (SELECT 1 FROM QT_results AS sub WHERE sub.rowid = main.rowid AND (sub."subject" LIKE '%revert%' OR sub."subject" LIKE '%deprecate%' OR sub."description" LIKE '%revert%' OR sub."description" LIKE '%deprecate%'))) 
AS filtered_data WHERE quartile = 3;