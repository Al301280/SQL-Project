# SQL-Project-2025-03-05

# Průvodní zpráva
## I.	Popis projektu
Tento projekt se zaměřuje na výzkum životní úrovně obyvatel České republiky, konkrétně na dostupnost základních potravin (např. chleba, vajec, mléka, cukru) pro širokou veřejnost. Poskytuje odpovědi na otázky uvedené ve třetí části této zprávy. Výsledky budou následně předány tiskovému oddělení, které je bude prezentovat na nadcházející konferenci věnované právě problematice dostupnosti základních potravin.

Podklady pro srovnání této dostupnosti byly vypracovány na základě oficiálních údajů o průměrných cenách a průměrných hrubých příjmech poskytnutých Úřadem vlády České republiky a pro srovnatelnost údajů bylo vybráno období let 2006–2018.

Závěrečná část zprávy obsahuje analýzu vlivu HDP na vývoj cen potravin a mezd ve stejném období, tedy v letech 2006–2018.


**Datové sady dostupné pro čerpání informací pro výzkum:**

*Primární tabulky*
1.	czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
2.	czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
3.	czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
4.	czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
5.	czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
6.	czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
7.	czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.
	
*Číselníky sdílených informací o ČR*
1.	czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
2.	czechia_district – Číselník okresů České republiky dle normy LAU.
	
*Dodatečné tabulky*
1.	countries – Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
2.	economies – HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

## II.	Výběr dat do view pro výzkum
### a.	v_alzbeta_kratinova_project_SQL_primary_final

Primární view s názvem v_alzbeta_kratinova_project_SQL_primary_final obsahuje následující sloupce/hodnoty:

**Year** – zajímají nás údaje na úrovni let, vyšší detail jako třeba kvartál či měsíc nebyl potřeba. Rok ve view byl použitý z tabulky czechia_payroll. View zobrazuje roky 2006 – 2018, protože pouze tyto roky jsou existují data pro mzdy a zároveň ceny potravin.

**Branch code** – z původního názvu industry_branch_code z tabulky czechia_payroll. Ve finálním view sice není pro zodpovězení výzkumných otázek nezbytný, ale byl ponechaný, protože podle něj napojujeme tabulku czechia_payroll_industry_branch, abychom získali název průmyslového odvětví. Jeho přítomnost zároveň vede k tomu, že view obsahuje kombinace všech odvětví a všech kategorií potravin pro daný rok (kartézský součin), což ale nevadí, protože s oběma dimenzemi dále pracujeme. 
Tabulka czechia_payroll sice obsahuje i průměr za všechna odvětví (industry_branch_code = NULL), ale pro možnost vidět detail na úrovni odvětví, jsou vybrané pouze nenulové hodnoty.

**Branch** – název průmyslového odvětví z tabulky czechia_payroll_industry_branch, který je pro další analýzu důležitý.

**Avg_wage_yearly** – dopočtený sloupec, protože dále pracujeme s průměrnou mzdou za daný rok. Byl získaný z tabulky czechia_payroll jako průměrná hodnota mzdy v daném průmyslovém odvětví a roce; jde o zprůměrování všech reportovaných hodnot v daném odvětví a roce. Výběr byl omezený pomocí calculation_code = 200 (z tabulky czechia_payroll_calculation), což je přepočtený (normalizovaný) ukazatel zaručující porovnatelnost napříč odvětvími. Tabulka czechia_payroll_calculation nebyla připojená, protože obsahuje jen 2 řádky a její napojení by zbytečně bobtnalo primární view. Ze stejného důvodu byla vynechaná i tabulka czechia_payroll_value_type (rovněž 2 řádky), z které byl použitý value_type_code = 5958 (Průměrná hrubá mzda na zaměstnance). Výpočet je seskupený podle kódu průmyslového odvětví a roku.

**Food_category_code** – kód kategorie potravin z tabulky czechia_price, na který je navázaná tabulka czechia_price_category. Stejně jako branch_code není nezbytný pro zodpovězení výzkumných otázek, ale byl ponechaný, protože umožňuje získat název kategorie potravin (food_category) a jejich jednotku měření (unit). Jeho přítomnost spolu s branch_code vede k tomu, že view obsahuje všechny kombinace odvětví a kategorií potravin za daný rok, což je očekávaný výsledek vzhledem k následnému napojování obou dimenzí.

**Avg_price_yearly** – dopočtená hodnota z tabulky czechia_price jako průměr cen dané kategorie potravin za rok, kde region_code = NULL (celorepublikový průměr). Výběr byl seskupený podle kategorie potravin (category_code) a roku.

 
*Použité tabulky:*

Czechia_payroll

Czechia_payroll_industry_branch

Czechia_price

Czechia_price_category


Napojení tabulek bylo provedené pomocí „join“ a „left join“. Na tabulku czechia_payroll byla pomocí „join“ napojená tabulka czechia_price na základě shodného roku, který je jediný společný identifikátor. Hledali jsme pouze ty hodnoty, které mají obě tabulky společné (rok). Na tabulku czechia_payroll byla dále napojená tabulka czechia_payroll_industry_branch pomocí „left join“, protože jsme potřebovali pro průmyslový kód najít název průmyslového odvětví. K tabulce czechia_price byla přes „left join“ napojená tabulka czechia_price_category, abychom zjistili název kategorie potravin.

Celé view je seřazené vzestupně podle roku, kódu průmyslového odvětví a kódu kategorie potravin.

### b.	v_alzbeta_kratinova_project_SQL_secondary_final

Další view s názvem v_alzbeta_kratinova_project_SQL_secondary_final využívá view v_alzbeta_kratinova_project_SQL_primary_final, na které je pomocí „left join“ připojená tabulka economies na základě shodného roku, abychom doplnili ukazatel HDP, a data jsou omezena pouze na Českou republiku. Ve view je dále přidaný agregovaný sloupec „avg_food_price_yearly“, který vznikl v CTE jako průměr všech kategorií potravin za daný rok (celorepublikový průměr).

View obsahuje následující sloupce/hodnoty:

**Year** – hodnoty jsou zobrazené na úrovni let, sledované období je opět za roky 2006 – 2018.

**Avg_wage_yearly** – průměrná roční mzda za všechny odvětví (stejně jako v předchozím view).

**Avg_food_price_yearly** – průměrná cena potravin všech kategorií za daný rok.

**Gdp** – je sloupec získaný z tabulky economies. Při srovnávání HDP pracujeme pouze s průměrnou cenu za celou kategorii, protože není důležitý detail, ale průměrná cena za celý „košík“.

*Použité tabulky/view:*

Economies

v_alzbeta_kratinova_project_SQL_primary_final


### c.	Nalezené problémy

Při práci s daty byly zjištěny určité nekonzistence a nečistoty v některých zdrojových tabulkách, například chybějící nebo duplicitní řádky, nesrovnalosti v hodnotách či drobné nepřesnosti, které mohly ovlivnit jejich přímé porovnávání. Při identifikaci těchto „nečistot“ byl zvolený takový postup filtrování a zpracování dat, aby nedošlo ke zkreslení výsledků.

Tabulka czechia_payroll obsahuje sloupec unit_code, ve kterém se vyskytují nesprávně přiřazené číselné kódy jednotek (např. tisíce osob nebo Kč), což je patrné i z tabulky czechia_payroll_unit. V tabulce czechia_payroll se totiž na stejných řádcích, kde jsou uvedeny průměrné počty zaměstnaných osob a ve sloupci value_type_code je správně uveden kód tohoto ukazatele, nachází ve sloupci unit_code kódy odpovídající průměrným mzdám. Sloupec unit_code proto nebyl při výpočtech zohledněný.

Tabulka economies obsahuje ve sloupci country v části záznamů (přibližně prvních 3 000 řádků) názvy regionů či jiných obecných seskupení zemí namísto názvů jednotlivých států a zároveň se v ní vyskytují duplicitní řádky. Pro účely analýzy bylo proto využito pouze HDP za Českou republiku, jelikož data o cenách a mzdách jsou k dispozici právě pro tento stát.

Výčet není vyčerpávající, jde jen o ta úskalí, která se během práce s daty objevila.


## III.	Výzkumné otázky
V této části budou zodpovězeny výzkumné otázky.

1.	Otázka: **Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**
   
Z meziročního srovnání průměrných mezd v jednotlivých odvětvích (sloupec wage_diff) vyplývá, že k největšímu počtu poklesů došlo v roce 2013, a to v 11 odvětvích z celkových 19. Dalšími roky s častějším poklesem mezd jsou roky 2009 a 2011, kdy došlo k meziročnímu poklesu ve čtyřech odvětvích.

Zároveň však existují odvětví, ve kterých za celé sledované období nedošlo ani k jednomu meziročnímu poklesu průměrné mzdy. Jedná se o odvětví Ostatní činnosti, Zdravotní a sociální péče a Zpracovatelský průmysl.
Z výsledků je dále patrné, že po roce 2013 mzdy rostly prakticky ve všech odvětvích. Výjimku tvoří odvětví Těžba a dobývání, kde se i po roce 2013 vyskytly dva meziroční poklesy, a rovněž Výroba a rozvod elektřiny, plynu, tepla a klimatizace vzduchu, kde došlo k jednomu poklesu.

V roce 2013 v České republice pokračovala již druhým rokem hospodářská recese, HDP klesalo dvě po sobě jdoucí období, rostla nezaměstnanost a firmy tak omezovaly růst mezd, což se promítlo i do vývoje průměrných mezd napříč odvětvími.

Nejčastěji docházelo k poklesu průměrné mzdy v odvětví Těžba a dobývání, a to celkem čtyřikrát za sledované období. Nicméně za celé období let 2006–2018 je celkový rozdíl průměrných mezd kladný, a lze proto konstatovat, že se jedná o dlouhodobě rostoucí trend, přestože v jeho průběhu docházelo k dílčím meziročním poklesům, zejména v roce 2013.

2.	Otázka: **Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**
   
Odpověď na tuto otázku je vzhledem k rostoucímu trendu alergií rozdělená nejdříve na počet kilogramů chleba a žádné mléko pro alergiky na laktózu a dále počet litrů mléka a žádný chléb pro alergiky na lepek. Odpověď nabízí přehledná tabulka:

| Rok  | Kategorie potravin               | Počet jednotek |
|------|----------------------------------|----------------|
| 2006 | Chléb konzumní kmínový           | 1312 kg        |
| 2018 | Chléb konzumní kmínový           | 1365 kg        |
| 2006 | Mléko polotučné pasterované      | 1465 l         |
| 2018 | Mléko polotučné pasterované      | 1669 l         |

Pokud ovšem budeme posuzovat vyvážený spotřební koš, tedy 1 kg chleba a 1 l mléka jako jeden set, dostaneme 692 setů v roce 2006 a 751 setů v roce 2018. 

3.	Otázka: **Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**
   
Výsledek je omezený na 5 nejnižších hodnot, protože 3 z nich se ukázaly jako neprůkazné – u některých kategorií potravin totiž dochází k meziročnímu poklesu ceny a zároveň nebylo jisté, zda se třetí nejnižší hodnota neopakuje u další kategorie. V našem případě zdražuje nejpomaleji kategorie Banány žluté (0,04 %).

4.	Otázka: **Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**
   
Podle dostupných dat k takové situaci ve sledovaném období nedošlo. Nejvyšší meziroční nárůst cen potravin byl zaznamenán v roce 2017, avšak v témže roce došlo i k růstu mezd (o 6,17 %), takže k výraznému rozdílu mezi vývojem cen a mezd nedošlo. 

5.	Otázka: **Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**
   
Na základě dostupných dat lze pozorovat, že růst HDP obvykle doprovází i růst mezd – tedy mezi těmito ukazateli existuje pozitivní vztah.

Naopak růst cen potravin se pohybuje nezávisleji na změnách HDP – reaguje spíše na jiné ekonomické faktory (např. inflaci, výrobní náklady či situaci na trhu).

Výrazné zvýšení HDP v jednom roce se zpravidla projeví růstem mezd již ve stejném nebo následujícím roce, ale nikoli nutně růstem cen potravin.

Na úrovni odvětví: Při porovnání meziročních růstů HDP a průměrných mezd podle jednotlivých odvětví lze pozorovat, že některé sektory (např. IT a finančnictví) reagují na růst HDP pružněji než jiné (např. zemědělství či školství).

Většina odvětví však sleduje podobný trend – v letech s vyšším růstem HDP dochází zpravidla také k růstu mezd, což potvrzuje pozitivní korelaci mezi výkonem ekonomiky a mzdovou úrovní.
Ceny potravin zůstávají relativně nezávislé, protože se odvíjejí spíše od inflačních vlivů než od HDP.

 
