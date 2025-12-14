-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- a) bez ohledu na odvětví, buď jen mléko (pro alergiky na lepek) nebo jen chléb (pro alergiky na laktózu) 
SELECT 
    v.year,
    v.food_category,
    ROUND(AVG(v.avg_wage_yearly) / AVG(v.avg_price_yearly), 2) AS units_affordable
FROM v_alzbeta_kratinova_project_SQL_primary_final v
WHERE v.food_category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
  AND v.year IN (
        (SELECT MIN(year) FROM v_alzbeta_kratinova_project_SQL_primary_final),
        (SELECT MAX(year) FROM v_alzbeta_kratinova_project_SQL_primary_final)
  )
GROUP BY v.year, v.food_category
ORDER BY v.food_category, v.year;


-- b) bez ohledu na odvětví, tentokrát kombinace mléko a chléb 1:1 (výsledek = 692 setů 1kg chleba a 1l mléka v roce 2006, 751 setů 1kg chleba a 1l mléka v roce 2018)  
SELECT 
    year,
    ROUND(AVG(avg_wage_yearly) / (AVG(CASE WHEN food_category = 'Mléko polotučné pasterované' THEN avg_price_yearly END) 
                                 + AVG(CASE WHEN food_category = 'Chléb konzumní kmínový' THEN avg_price_yearly END)), 2) 
        AS set_milk_and_bread
FROM v_alzbeta_kratinova_project_SQL_primary_final
WHERE food_category IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
AND year IN (
        (SELECT MIN(year) FROM v_alzbeta_kratinova_project_SQL_primary_final),
        (SELECT MAX(year) FROM v_alzbeta_kratinova_project_SQL_primary_final)
  )
GROUP BY year
ORDER BY year;


-- c) záleží na odvětví (nejméně chleba nebo mléka v I-Ubytování, stravování a pohostinství, nejvíce v K-Peněžnictví a pojišťovnictví v roce 2006, rychleji zřejmě rostly průměrné mzdy v J-Informačních a komunikačních činnostech, protože předběhly "K" v 2018)
SELECT
    v.year,
    v.branch_code,
    v.branch,
    v.food_category,
    ROUND(v.avg_wage_yearly / v.avg_price_yearly, 2) AS units_affordable
FROM v_alzbeta_kratinova_project_SQL_primary_final v
WHERE v.food_category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
AND v.year IN (
        (SELECT MIN(year) FROM v_alzbeta_kratinova_project_SQL_primary_final),
        (SELECT MAX(year) FROM v_alzbeta_kratinova_project_SQL_primary_final)
  )
ORDER BY v.branch_code, v.food_category, v.year;