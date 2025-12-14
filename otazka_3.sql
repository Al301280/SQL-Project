-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

WITH yearly_changes AS (
    SELECT
        food_category,
        year,
        avg_price_yearly,
        LAG(avg_price_yearly) OVER (PARTITION BY food_category ORDER BY year) AS prev_price
    FROM v_alzbeta_kratinova_project_SQL_primary_final
)
SELECT
    food_category,
    ROUND(AVG((avg_price_yearly - prev_price) / prev_price * 100), 2) AS avg_percent_growth
FROM yearly_changes
WHERE prev_price IS NOT NULL
GROUP BY food_category
ORDER BY avg_percent_growth ASC
LIMIT 5; 

