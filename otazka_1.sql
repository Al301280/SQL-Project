-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- a) rozdíl průměrné mzdy v odvětvích v meziročním srovnání
WITH wages AS (
    SELECT DISTINCT 
        branch_code, branch, year, avg_wage_yearly
    FROM v_alzbeta_kratinova_project_sql_primary_final
)
SELECT 
    branch_code,
    branch,
    year,
    avg_wage_yearly,
    LAG(avg_wage_yearly) OVER (
        PARTITION BY branch_code 
        ORDER BY year
    ) AS wage_last_year,
    avg_wage_yearly 
        - LAG(avg_wage_yearly) OVER (
            PARTITION BY branch_code 
            ORDER BY year
        ) AS wage_diff
FROM wages
ORDER BY branch_code, year;


-- b) pouze meziroční poklesy (C-Zpracovatelský průmysl, Q-Zdravotní a sociální péče a S-Ostatní činnosti - nezaznamenaly žádný pokles, nejhůře si vedlo B-Těžba a dobývání)
WITH wages AS (
    SELECT DISTINCT 
        branch_code, 
        branch, 
        year, 
        avg_wage_yearly
    FROM v_alzbeta_kratinova_project_SQL_primary_final
),
wages_diff AS (
    SELECT
        branch_code,
        branch,
        year,
        avg_wage_yearly,
        avg_wage_yearly - LAG(avg_wage_yearly) OVER (PARTITION BY branch_code ORDER BY year) AS wage_diff
    FROM wages
)
SELECT
    branch_code,
    branch,
    COUNT(*)
AS years_with_drop
FROM wages_diff
WHERE wage_diff < 0
GROUP BY branch_code, branch
ORDER BY years_with_drop DESC;


-- c) celkový rozdíl za sledované období
WITH wages AS (
    SELECT DISTINCT 
        branch_code, branch, year, avg_wage_yearly,
        LAG(avg_wage_yearly) OVER (PARTITION BY branch_code ORDER BY year) AS wage_last_year
    FROM v_alzbeta_kratinova_project_SQL_primary_final
),
wages_diff AS (
    SELECT
        branch_code,
        branch,
        year,
        avg_wage_yearly,
        avg_wage_yearly - wage_last_year AS wage_diff
    FROM wages
)
SELECT 
    branch_code,
    branch,
    SUM(wage_diff) AS total_wage_diff,
    CASE 
        WHEN SUM(wage_diff) > 0 THEN 'grow'
        WHEN SUM(wage_diff) < 0 THEN 'drop'
        ELSE 'stagnate'
    END AS wage_evolution
FROM wages_diff
GROUP BY branch, branch_code
ORDER BY total_wage_diff DESC ;

