CREATE OR REPLACE VIEW v_alzbeta_kratinova_project_sql_secondary_final AS

WITH avg_food AS (
    SELECT
        YEAR,
        ROUND(AVG(avg_price_yearly)::numeric, 2) AS avg_food_price_yearly
    FROM v_alzbeta_kratinova_project_SQL_primary_final
    GROUP BY YEAR
),    
avg_wage AS (
    SELECT 
        year,
        ROUND(AVG(avg_wage_yearly)::numeric, 2) AS avg_wage_yearly
    FROM v_alzbeta_kratinova_project_SQL_primary_final
    GROUP BY YEAR
)
SELECT 
    w.year,
    w.avg_wage_yearly,
    f.avg_food_price_yearly,
    ROUND(AVG(e.gdp)::numeric,2) AS gdp
FROM avg_wage w
LEFT JOIN avg_food f
    ON w.year = f.year
LEFT JOIN economies e
    ON w.year = e.year AND e.country = 'Czech Republic'
GROUP BY w.year, w.avg_wage_yearly, f.avg_food_price_yearly
ORDER BY w.YEAR ASC;