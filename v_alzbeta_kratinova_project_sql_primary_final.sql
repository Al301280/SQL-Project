CREATE OR REPLACE
VIEW v_alzbeta_kratinova_project_SQL_primary_final AS

SELECT
	cpay.payroll_year AS year,
	cpay.industry_branch_code AS branch_code,
	cpib.name AS branch,
	cpay.avg_wage_yearly,
	cp.category_code AS food_category_code,
	cpcat.name AS food_category,
	cpcat.price_unit AS unit,
	cp.avg_price_yearly
FROM (
	SELECT
		industry_branch_code,
		payroll_year,
		round(avg(value):: NUMERIC, 2) AS avg_wage_yearly
	FROM czechia_payroll
	WHERE
		calculation_code = 200
		AND value_type_code = 5958
		AND industry_branch_code IS NOT NULL
	GROUP BY
		industry_branch_code,
		payroll_year)
 cpay
JOIN (
	SELECT
		category_code,
		DATE_PART('year', date_from)::int AS year,
		ROUND(AVG(value)::NUMERIC, 2) AS avg_price_yearly
	FROM czechia_price
	WHERE
		region_code IS NULL
	GROUP BY
		category_code,
		YEAR) 
 cp 
ON cpay.payroll_year = cp.year
LEFT JOIN czechia_payroll_industry_branch AS cpib
ON cpib.code = cpay.industry_branch_code
LEFT JOIN czechia_price_category AS cpcat
ON cp.category_code = cpcat.code
ORDER BY
	year ASC,
	industry_branch_code ASC,
	category_code ASC ;

