--  selecting all columns from the 'suicide rate' table
select * from [suicide rate];

--  selecting the maximum number of suicides for each country and sorts the results by country name
SELECT country, MAX(suicides_no) AS max_suicides
FROM [suicide rate]
GROUP BY country
order by country;

-- selecting the top10 countries with highest suicide rates
SELECT top 10 country, SUM(suicides_no) AS total_suicides
FROM [suicide rate]
where sex='male'
GROUP BY  country
order by country desc;

-- This query selects the maximum number of suicides for each year and sorts the results by year in descending order
SELECT year,sex, MAX(suicides_no) AS max_suicides
FROM [suicide rate]
GROUP BY year,sex
order by year desc;

-- This query selects the maximum number of suicides for each country and generation, and sorts the results by country name
SELECT country, generation, MAX(suicides_no) AS max_suicides
FROM [suicide rate]
GROUP BY generation, country
order by country;

-- This query selects the average number of suicides for each age and sex, and sorts the results by age
SELECT age, sex, round(AVG(suicides_no),2) AS avg_suicides
FROM [suicide rate]
GROUP BY age, sex
order by age;
