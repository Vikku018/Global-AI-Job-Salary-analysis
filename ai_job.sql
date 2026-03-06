DROP DATABASE IF EXISTS AI_JOB_SALARY_DB;

CREATE DATABASE AI_JOB_DATASET_DB

USE  AI_JOB_DATASET_DB;

SELECT * FROM ai_job;

-- 1. Find average salary for each job title ?
SELECT JOB_TITLE,
    ROUND(avg(SALARY), 2)
FROM ai_job
GROUP BY JOB_TITLE;

-- 2. Find top 5 highest paying job roles ?
SELECT DISTINCT JOB_TITLE,
    SALARY
FROM ai_job
ORDER BY SALARY DESC
LIMIT 5;

-- 3. Calculate average salary by experience level (Junior, Mid, Senior) ?
SELECT EXPERIENCE_LEVEL,
    ROUND(avg(SALARY), 2) AS avg_salary
FROM ai_job
group by EXPERIENCE_LEVEL;

-- 4. Find number of jobs available in each location ?
SELECT COMPANY_LOCATION,
    COUNT(JOB_TITLE) AS "NO_OF JOB"
FROM ai_job
GROUP BY COMPANY_LOCATION;

-- 5. Find average salary by company to compare companies ?
SELECT COMPANY_NAME,
    ROUND(avg(SALARY), 2) AS avg_salary
FROM ai_job
GROUP BY COMPANY_NAME
ORDER BY avg_salary DESC;

-- 6. Identify the city with highest average salary ?
SELECT COMPANY_LOCATION,
    ROUND(avg(SALARY), 2) AS avg_salary
FROM AI_JOB
GROUP BY COMPANY_LOCATION
ORDER BY avg_salary DESC
LIMIT 1;

-- 7. Find number of remote vs onsite jobs ?
SELECT WORK_MODE,
    COUNT(JOB_ID) AS "NO_OF JOBS"
FROM AI_JOB
WHERE WORK_MODE = "On-Site" OR WORK_MODE = "Remote"
GROUP BY WORK_MODE;

-- 8. Calculate average salary by employment type (Full-time, Contract, etc.) ?
SELECT EMPLOYMENT_TYPE, 
    ROUND(avg(SALARY), 2) AS avg_salary
FROM AI_JOB
group by EMPLOYMENT_TYPE;

-- 9. Find job titles that appear more than 50 times to identify popular roles ?
SELECT JOB_TITLE,
       COUNT(*) AS job_count
FROM AI_JOB
GROUP BY JOB_TITLE
HAVING COUNT(*) > 50
ORDER BY job_count DESC;

-- 10. Find minimum, maximum, and average salary overall ?
SELECT JOB_TITLE, AVG(SALARY) AS avg_salary, 
                  MAX(SALARY) AS max_salary,
                  MIN(SALARY) AS min_salary
FROM AI_JOB
GROUP BY JOB_TITLE;

-- 11. Find companies offering salaries above overall average ?
SELECT COMPANY_NAME,
    ROUND(avg(SALARY), 2) AS avg_salary
FROM AI_JOB
GROUP BY COMPANY_NAME
HAVING AVG(SALARY) > (
                 SELECT AVG(SALARY) 
                 FROM AI_JOB
                 );


-- 12. Identify top 5 locations with most job openings ?
SELECT COMPANY_LOCATION,
    COUNT(JOB_TITLE) AS "no_of job"
FROM AI_JOB 
GROUP BY COMPANY_LOCATION
ORDER BY "no_of job" DESC
LIMIT 5;

-- 13. Find salary trend by experience (order from lowest to highest) ?
SELECT EXPERIENCE_LEVEL,
    ROUND(avg(SALARY), 2) AS avg_salary
FROM AI_JOB
GROUP BY EXPERIENCE_LEVEL;

-- 14. Find duplicate job records based on job title + company + location ?
SELECT JOB_TITLE,
    COMPANY_NAME,
    COMPANY_LOCATION,
    COUNT(*) AS "no_of repetition"
FROM ai_job
GROUP BY JOB_TITLE, COMPANY_NAME, COMPANY_LOCATION
HAVING COUNT(*) > 1;

-- 15. identify the highest-paying job role in each company_location.
SELECT DISTINCT COMPANY_LOCATION,
    JOB_TITLE,
    SALARY 
FROM (
    SELECT COMPANY_LOCATION,
           JOB_TITLE,
           SALARY,
           DENSE_RANK() OVER (
               PARTITION BY COMPANY_LOCATION
               ORDER BY SALARY DESC
           ) AS rnk
    FROM AI_JOB
) t
WHERE rnk = 1;

-- 16. Find top 10 most in-demand skills across all job postings ?  
SELECT 
    REQUIRED_SKILLS,
    ROUND(AVG(salary),2) AS "Average Salary",
    COUNT(*) AS demand_count
FROM AI_JOB
GROUP BY REQUIRED_SKILLS
ORDER BY demand_count DESC
LIMIT 10;


-- 17. Which skills appear most frequently in high-paying jobs (above average salary) ?
SELECT 
    js.REQUIRED_SKILLS AS skill,
    COUNT(*) AS frequency
FROM AI_JOB js
JOIN AI_JOB j ON js.job_id = j.job_id
WHERE j.salary > (SELECT AVG(salary) FROM AI_JOB)
GROUP BY js.REQUIRED_SKILLS
ORDER BY frequency DESC
LIMIT 10;


-- 18. Which skills are common in Senior-level roles compared to Junior roles ?
SELECT 
    js.REQUIRED_SKILLS,
    j.EXPERIENCE_LEVEL,
    COUNT(*) AS frequency
FROM AI_JOB j
JOIN AI_JOB js ON j.job_id = js.job_id
WHERE j.EXPERIENCE_LEVEL IN ('Junior', 'Senior')
GROUP BY j.EXPERIENCE_LEVEL, js.REQUIRED_SKILLS
ORDER BY j.EXPERIENCE_LEVEL, frequency DESC;