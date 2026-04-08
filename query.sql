--Age-wise trend analysis
SELECT o.age_group, o.year, AVG(o.mean_estimate) AS avg_obesity, AVG(m.mean_estimate) AS avg_malnutrition
FROM obesity_data o
JOIN malnutrition_data m ON o.country = m.country AND o.year = m.year AND o.age_group = m.age_group
GROUP BY o.age_group, o.year
ORDER BY o.age_group, o.year;
--highest average obesity levels
SELECT region, AVG(mean_estimate) AS avg_obesity
FROM obesity_data
WHERE year = 2022
GROUP BY region
ORDER BY avg_obesity DESC
LIMIT 5;
--Top 5 countries with highest obesity estimates
SELECT country, region, MAX(mean_estimate) AS max_obesity
FROM obesity_data
GROUP BY country, region
ORDER BY max_obesity DESC
LIMIT 5;
--Obesity trend in India
SELECT year, AVG(mean_estimate) AS avg_obesity
FROM obesity_data
WHERE country = 'INDIA'
GROUP BY year
ORDER BY year;
--Average obesity by gender
SELECT gender, AVG(mean_estimate) AS avg_obesity
FROM obesity_data
GROUP BY gender;
--Country count by obesity level category and age group
SELECT obesity_level, age_group, COUNT(DISTINCT country) AS country_count
FROM obesity_data
GROUP BY obesity_level, age_group;
--Top 5 least reliable
SELECT country, AVG(ci_width) AS avg_ci
FROM obesity_data
GROUP BY country
ORDER BY avg_ci DESC
LIMIT 5;
--Top 5 most consistent
SELECT country, AVG(ci_width) AS avg_ci
FROM obesity_data
GROUP BY country
ORDER BY avg_ci ASC
LIMIT 5;
--Average obesity by age group
SELECT age_group, AVG(mean_estimate) AS avg_obesity
FROM obesity_data
GROUP BY age_group;
--Top 10 countries with consistent low obesity (low average + low CI) over the years
SELECT country, AVG(mean_estimate) AS avg_obesity, AVG(ci_width) AS avg_ci
FROM obesity_data
GROUP BY country
HAVING avg_obesity < 25 AND avg_ci < 2
ORDER BY avg_obesity ASC, avg_ci ASC
LIMIT 10;
--Countries where female obesity exceeds male by large margin (same year)
SELECT o1.country, o1.year, (o1.mean_estimate - o2.mean_estimate) AS diff
FROM obesity_data o1
JOIN obesity_data o2
  ON o1.country = o2.country AND o1.year = o2.year
WHERE o1.gender = 'Female' AND o2.gender = 'Male'
  AND (o1.mean_estimate - o2.mean_estimate) > 5;
--Global average obesity percentage per year
SELECT year, AVG(mean_estimate) AS global_avg_obesity
FROM obesity_data
GROUP BY year
ORDER BY year;
--Avg. malnutrition by age group
SELECT age_group, AVG(mean_estimate) AS avg_malnutrition
FROM malnutrition_data
GROUP BY age_group;
--Top 5 countries with highest malnutrition (mean_estimate)
SELECT country, region, MAX(mean_estimate) AS max_malnutrition
FROM malnutrition_data
GROUP BY country, region
ORDER BY max_malnutrition DESC
LIMIT 5;
--Malnutrition trend in African region over the years
SELECT year, AVG(mean_estimate) AS avg_malnutrition
FROM malnutrition_data
WHERE region = 'Africa'
GROUP BY year
ORDER BY year;
--Gender-based average malnutrition
SELECT gender, AVG(mean_estimate) AS avg_malnutrition
FROM malnutrition_data
GROUP BY gender;
--Malnutrition level-wise (average CI_Width by age group)
SELECT malnutrition_level, age_group, AVG(ci_width) AS avg_ci
FROM malnutrition_data
GROUP BY malnutrition_level, age_group;
--Yearly malnutrition change in
SELECT country, year, AVG(mean_estimate) AS avg_malnutrition
FROM malnutrition_data
WHERE country IN ('India', 'Nigeria', 'Brazil')
GROUP BY country, year
ORDER BY country, year;
--Regions with lowest malnutrition averages
SELECT region, AVG(mean_estimate) AS avg_malnutrition
FROM malnutrition_data
GROUP BY region
ORDER BY avg_malnutrition ASC
LIMIT 5;
--Countries with increasing malnutrition
SELECT country, MIN(mean_estimate) AS min_mal, MAX(mean_estimate) AS max_mal
FROM malnutrition_data
GROUP BY country
HAVING (MAX(mean_estimate) - MIN(mean_estimate)) > 0;
--Min/Max malnutrition levels year-wise comparison
SELECT year, MIN(mean_estimate) AS min_malnutrition, MAX(mean_estimate) AS max_malnutrition
FROM malnutrition_data
GROUP BY year
ORDER BY year;
--High CI_Width flags for monitoring
SELECT *
FROM malnutrition_data
WHERE ci_width > 5;
--Obesity vs malnutrition comparison by country
SELECT o.country, AVG(o.mean_estimate) AS avg_obesity, AVG(m.mean_estimate) AS avg_malnutrition
FROM obesity_data o
JOIN malnutrition_data m ON o.country = m.country
GROUP BY o.country
LIMIT 5;
--Gender-based disparity in both obesity and malnutrition
SELECT o.gender, AVG(o.mean_estimate) AS avg_obesity, AVG(m.mean_estimate) AS avg_malnutrition
FROM obesity_data o
JOIN malnutrition_data m ON o.gender = m.gender AND o.country = m.country AND o.year = m.year
GROUP BY o.gender;
--Region-wise avg estimates side-by-side
SELECT o.region, AVG(o.mean_estimate) AS avg_obesity, AVG(m.mean_estimate) AS avg_malnutrition
FROM obesity_data o
JOIN malnutrition_data m ON o.region = m.region AND o.country = m.country AND o.year = m.year
WHERE o.region IN ('Africa', 'Americas')
GROUP BY o.region;
--Age-wise trend analysis
SELECT o.age_group, o.year, AVG(o.mean_estimate) AS avg_obesity, AVG(m.mean_estimate) AS avg_malnutrition
FROM obesity_data o
JOIN malnutrition_data m ON o.country = m.country AND o.year = m.year AND o.age_group = m.age_group
GROUP BY o.age_group, o.year
ORDER BY o.age_group, o.year;
--Line chart: Global obesity & malnutrition trends
SELECT
    year,
    'Obesity' AS type,
    AVG(mean_estimate) AS avg_value
FROM obesity_data
GROUP BY year
UNION ALL
SELECT
    year,
    'Malnutrition' AS type,
    AVG(mean_estimate) AS avg_value
FROM malnutrition_data
GROUP BY year
ORDER BY year, type;
--Bar chart: Top 10 countries by obesity vs malnutrition
SELECT * FROM (
    SELECT
        country,
        'Obesity' AS type,
        AVG(mean_estimate) AS avg_value
    FROM obesity_data
    GROUP BY country
    ORDER BY avg_value DESC
    LIMIT 10
) AS obesity_top

UNION ALL

SELECT * FROM (
    SELECT
        country,
        'Malnutrition' AS type,
        AVG(mean_estimate) AS avg_value
    FROM malnutrition_data
    GROUP BY country
    ORDER BY avg_value DESC
    LIMIT 10
) AS malnutrition_top;
--Map visual: Highlight regions based on obesity levels
SELECT
    region,
    country,
    AVG(mean_estimate) AS avg_obesity
FROM obesity_data
GROUP BY region, country;
--Stacked bar: Obesity and malnutrition by gender
select * from (SELECT
    gender,
    'Obesity' AS type,
    AVG(mean_estimate) AS avg_value
FROM obesity_data
GROUP BY gender) as ob

UNION ALL
select * from (
SELECT
    gender,
    'Malnutrition' AS type,
    AVG(mean_estimate) AS avg_value
FROM malnutrition_data
GROUP BY gender )as ml;
--Pie chart: Country count by obesity/malnutrition level
select  * from (SELECT
    obesity_level AS level,
    COUNT(DISTINCT country) AS country_count,'ob' as TY
FROM obesity_data
GROUP BY obesity_level) as ob

UNION ALL
select * from (
SELECT
    malnutrition_level AS level,
    COUNT(DISTINCT country) AS country_count,'ml' as TY
FROM malnutrition_data
GROUP BY malnutrition_level) as ml;
--Heatmap: CI_Width distribution by region
SELECT
    region,
    year,
    AVG(ci_width) AS avg_ci_width
FROM obesity_data
GROUP BY region, year;
--Dual-line: Obesity vs malnutrition trend in a country
select * from (SELECT
    year,
    'Obesity' AS type,
    AVG(mean_estimate) AS avg_value
FROM obesity_data
WHERE country = 'India' -- Change to your country
GROUP BY year) as ob

UNION ALL
select * from (
SELECT
    year,
    'Malnutrition' AS type,
    AVG(mean_estimate) AS avg_value
FROM malnutrition_data
WHERE country = 'India' -- Change to your country
GROUP BY year
ORDER BY year, type )as ml;
--Scatter plot: Obesity vs malnutrition per country
SELECT
    o.country,
    AVG(o.mean_estimate) AS avg_obesity,
    AVG(m.mean_estimate) AS avg_malnutrition
FROM obesity_data o
JOIN malnutrition_data m ON o.country = m.country
GROUP BY o.country;
--Treemap: Obesity burden per region
SELECT
    region,
    country,
    SUM(mean_estimate) AS obesity_burden
FROM obesity_data
GROUP BY region, country;
--Decomposition tree: Drill down
SELECT
    region,
    country,
    age_group,
    gender,
    AVG(mean_estimate) AS avg_obesity
FROM obesity_data
GROUP BY region, country, age_group, gender;  

