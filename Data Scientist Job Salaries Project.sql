-- How many job titles are there?

SELECT COUNT (DISTINCT(job_title))
FROM job_salaries

-- What are the job titles?

SELECT DISTINCT (job_title), COUNT (job_title) OVER (PARTITION BY job_title)
FROM job_salaries
ORDER BY count DESC;

--Top 10 most paid salaries vs the average pay for the job

SELECT job_title, salary, AVG(salary)
OVER (PARTITION BY job_title) AS avg_salary
FROM job_salaries
ORDER BY salary DESC
LIMIT 10

--Top 5 most popular jobs and their average pay

SELECT job_title, AVG(salary), COUNT(job_title) AS counts
FROM job_salaries
GROUP BY job_title
ORDER BY counts DESC
LIMIT 5

--What is the average pay for each country?

SELECT name, ROUND(AVG(salary),2) AS country_avg
FROM job_salaries
LEFT JOIN country_names
ON job_salaries.company_location = country_names.code
GROUP BY name
ORDER BY country_avg DESC

-- Do countries pay alot more than their country’s average? which ones?

WITH avg_table AS (
	SELECT job_title, salary, company_location, AVG(salary)
	OVER (PARTITION BY company_location) AS country_avg
	FROM job_salaries
	)
SELECT job_title, salary, name, country_avg, COUNT(company_location)
OVER (PARTITION BY company_location) AS country_counts
FROM avg_table
LEFT JOIN country_names
ON avg_table.company_location=country_names.code
WHERE  salary>country_avg
ORDER BY country_counts DESC
	
-- What is the average pay of entry-level jobs?

SELECT experience_level, ROUND (AVG(salary),2)
FROM job_salaries
GROUP BY experience_level


-- Which countries pay their entry-level jobs above the general average pay for entry-level jobs?

SELECT name, AVG(salary)
FROM job_salaries
LEFT JOIN country_names
ON job_salaries.company_location = country_names.code
WHERE experience_level = 'EN'
GROUP BY name
HAVING AVG(salary)>59719.95
ORDER BY avg DESC

-- Is there a change in average entry-level pay yearly?

SELECT year, ROUND(AVG(salary),2)
FROM job_salaries
WHERE experience_level = 'EN'
GROUP BY year
ORDER BY year

-- How many fully remote jobs are there?

SELECT mobility, COUNT(mobility)
FROM job_salaries
GROUP BY mobility

-- Do countries pay fully remote entry-level jobs well?

SELECT name, AVG(salary) AS remote_avg
FROM job_salaries
LEFT JOIN country_names
ON job_salaries.company_location = country_names.code
WHERE experience_level = 'EN' AND mobility = 'Full Remote'
GROUP BY name
ORDER BY remote_avg DESC






































-- What is the average pay for each country?
SELECT ROUND(AVG(salary),2) AS country_avg
FROM job_salaries
LEFT JOIN countries_codes
ON job_salaries.company_location = countries_codes.code
GROUP BY name
ORDER BY country_avg


