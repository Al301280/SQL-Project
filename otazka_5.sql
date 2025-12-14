--Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

WITH data AS (
    SELECT 
        year,
        AVG(avg_wage_yearly) AS avg_wage_yearly,
        AVG(avg_food_price_yearly) AS avg_food_price_yearly,
        AVG(gdp) AS gdp
    FROM v_alzbeta_kratinova_project_sql_secondary_final
    WHERE gdp IS NOT NULL
    AND year BETWEEN 2006 AND 2018
    GROUP BY year
),
diffs AS (
    SELECT
        year,
        avg_wage_yearly,
        avg_food_price_yearly,
        gdp,
        LAG(avg_wage_yearly) OVER (ORDER BY year) AS prev_wage,
        LAG(avg_food_price_yearly) OVER (ORDER BY year) AS prev_food,
        LAG(gdp) OVER (ORDER BY year) AS prev_gdp
    FROM data
)
SELECT
    year,
    ROUND(((avg_wage_yearly - prev_wage) / prev_wage) * 100, 2) AS wage_growth_pct,
    ROUND(((avg_food_price_yearly - prev_food) / prev_food) * 100, 2) AS food_growth_pct,
    ROUND(((gdp - prev_gdp) / prev_gdp) * 100, 2) AS gdp_growth_pct
FROM diffs
WHERE prev_wage IS NOT NULL
ORDER BY year;
