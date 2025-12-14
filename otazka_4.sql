-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH yearly_avg AS (
    SELECT
        year,
        AVG(avg_price_yearly) AS avg_food_price,
        AVG(avg_wage_yearly) AS avg_wage
    FROM v_alzbeta_kratinova_project_SQL_primary_final
    GROUP BY year
),
yearly_growth AS (
    SELECT
        year,
        avg_food_price,
        avg_wage,
        LAG(avg_food_price) OVER (ORDER BY year) AS prev_food_price,
        LAG(avg_wage) OVER (ORDER BY year) AS prev_wage
    FROM yearly_avg
)
SELECT
    year,
    ROUND((avg_food_price - prev_food_price) / prev_food_price * 100, 2) AS food_price_growth_pct,
    ROUND((avg_wage - prev_wage) / prev_wage * 100, 2) AS wage_growth_pct
FROM yearly_growth
WHERE prev_food_price IS NOT NULL
  AND ( (avg_food_price - prev_food_price) / prev_food_price * 100
        - (avg_wage - prev_wage) / prev_wage * 100 ) > 10
ORDER BY year;


-- vyčíslení za každý rok zvlášť
WITH yearly_avg AS (
    SELECT
        year,
        AVG(avg_price_yearly) AS avg_food_price,
        AVG(avg_wage_yearly) AS avg_wage
    FROM v_alzbeta_kratinova_project_SQL_primary_final
    GROUP BY year
),
yearly_growth AS (
    SELECT
        year,
        avg_food_price,
        avg_wage,
        LAG(avg_food_price) OVER (ORDER BY year) AS prev_food_price,
        LAG(avg_wage) OVER (ORDER BY year) AS prev_wage
    FROM yearly_avg
)
SELECT
    year,
    ROUND((avg_food_price - prev_food_price) / prev_food_price * 100, 2) AS food_price_growth_pct,
    ROUND((avg_wage - prev_wage) / prev_wage * 100, 2) AS wage_growth_pct,
    ROUND(( (avg_food_price - prev_food_price) / prev_food_price * 100 )
          - ( (avg_wage - prev_wage) / prev_wage * 100 ), 2) AS difference_pct
FROM yearly_growth
WHERE prev_food_price IS NOT NULL
ORDER BY year;


