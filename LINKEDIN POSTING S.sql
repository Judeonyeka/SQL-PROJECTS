   /* Name: Jude Onyeka
      Date:08/25/2026
      Project: Linkedln_Job_Posting

 
                                        MY OBJECTIVE:
-- This is a job-market dataset, and the main purpose is to analyze the relationship between jobs, employers,
   compensation, skills, locations, industries, and working arrangements.
*/

--FIRST STEP: CREATING DATAS

CREATE DATABASE Linkedln                                 -- Creating a Database

ALTER DATABASE Linkedln                                  -- Renaming a Database
MODIFY NAME = Linkedln_Job_Posting;

USE Linkedln_Job_Posting                                 -- Use a Database

--SECOND STEP: LOADING/INSERTING THE DATAS

DROP TABLE Companies
CREATE TABLE Companies(
company_id	Int,
[name] Varchar(1000),
[description] Varchar(4000),	
company_size int,
[state] Varchar(50),
country	Varchar(50),
city Varchar(150),	
zip_code Varchar(200),
[address] Varchar(200),
[url] Varchar(200)
)

BULK INSERT Companies
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\companies\companies.csv'
WITH
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
);
--------------------------------------------------------------------------------------------------------------

DROP TABLE Company_industries
CREATE TABLE Company_industries (
company_id	BIGINT,
industry Varchar(200)
)

BULK INSERT Company_industries
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\companies\Company_industries.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ','
);

----------------------------------------------------------------------------------------------------------------
DROP TABLE Company_specialities
CREATE TABLE Company_specialities(
company_id	INT,
speciality  VARCHAR(2000)
);

BULK INSERT Company_specialities
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\companies\company_specialities.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ','
)

----------------------------------------------------------------------------------------------------------------

CREATE TABLE employee_counts(
company_id	INT,
employee_count	INT,
follower_count	INT,
time_recorded BIGINT
);

BULK INSERT employee_counts
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\companies\employee_counts.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0X0a'
)
-----------------------------------------------------------------------------------------------------------------
DROP TABLE BENEFITS
CREATE TABLE BENEFITS(
job_id	BIGINT,
inferred INT,
[type] VARCHAR(50)
)

BULK INSERT BENEFITS
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Linkedln_Job\jobs\benefits.csv'
WITH 
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
--------------------------------------------------------------------------------------------------------------------

CREATE TABLE Job_industries(
job_id	BIGINT,
industry_id INT
)

BULK INSERT Job_industries
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\jobs\job_industries.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
-----------------------------------------------------------------------------------------------------------------

CREATE TABLE job_skills(
job_id BIGINT,
skill_abr Varchar(20)
);

ALTER TABLE job_skills
ALTER COLUMN skill_abr varchar(30);

BULK INSERT job_skills
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\jobs\job_skills.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
);
----------------------------------------------------------------------------------------------------------------
drop table salaries
CREATE TABLE Salaries(
salary_id	INT,
job_id	BIGINT,
max_salary	decimal(12,2),
med_salary	decimal(12,2),
min_salary	decimal(12,2),
pay_period	Varchar(20),
currency	Varchar(20),
compensation_type Varchar(20)
);

BULK INSERT Salaries
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\jobs\Salaries.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
);
--------------------------------------------------------------------------------------------------------------
CREATE TABLE industries(
industry_id INT,
industry_name Varchar(50)
)

ALTER TABLE industries
ALTER COLUMN industry_name Varchar(100) null

BULK INSERT industries
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\mappings\industries.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ','
);

----------------------------------------------------------------------------------------------------------------

CREATE TABLE Skills(
skill_abr Varchar(10),
skill_name Varchar(50)
)

BULK INSERT Skills
FROM 'C:\Users\jonye\OneDrive\Documents\Linkedln_Job\mappings\skills.csv'
WITH 
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR ='0x0a'
)
---------------------------------------------------------------------------------------------------------------
DROP TABLE postings
CREATE TABLE postings(
    job_id BIGINT,
    company_name VARCHAR(500),
    title VARCHAR(500),
    [description] VARCHAR(MAX),
    max_salary VARCHAR(30),
    pay_period VARCHAR(50),
    [location] VARCHAR(150),
    company_id varchar(30),
    [views] VARCHAR(30),
    med_salary VARCHAR(30),
    min_salary VARCHAR(30),
    formatted_work_type VARCHAR(50),
    applies VARCHAR(30),
    original_listed_time VARCHAR(30),
    remote_allowed VARCHAR(30),
    job_posting_url VARCHAR(700),
    application_url VARCHAR(700),
    application_type VARCHAR(50),
    expiry VARCHAR(30),
    closed_time VARCHAR(30),
    formatted_experience_level VARCHAR(100),
    skills_desc VARCHAR(MAX),
    listed_time VARCHAR(30),
    posting_domain VARCHAR(100),
    sponsored VARCHAR(30),
    work_type VARCHAR(50),
    currency VARCHAR(10),
    compensation_type VARCHAR(30),
    normalized_salary VARCHAR(30),
    zip_code VARCHAR(20),
    fips VARCHAR(20)
);

BULK INSERT postings
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Linkedln_Job\postings.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '0x0a'

);
-------------------------------------------------------------------------------------------------------------
--RELATIONSHIPS


SELECT TOP 1 *                --CO
FROM Companies

SELECT TOP 1 * 
FROM Company_industries       --CI

SELECT TOP 1 * 
FROM Company_specialities     --CS

SELECT TOP 1 * 
FROM employee_counts          --E

SELECT TOP 1 * 
FROM postings                 --P

SELECT TOP 1 *
FROM industries               --I

SELECT TOP 1 *
FROM Job_industries           --JI

SELECT TOP 1 * 
FROM job_skills               --JS

SELECT TOP 1 * 
FROM Skills                   --SK

SELECT TOP 1 * 
FROM Salaries                 --SL

SELECT TOP 1 *                --B
FROM BENEFITS

--CTE
WITH Company_Table AS             --c
(
SELECT
      co.Company_id,
      co.[name],
      co.[description],
      co.company_size,
      co.[State],
      co.city,
      co.zip_code,
      co.country,
      ci.industry,
      cs.speciality
FROM  Companies co
LEFT JOIN Company_industries ci
ON co.company_id = ci.company_id
LEFT JOIN Company_specialities cs
ON co.company_id = cs.company_id

),
 --SELECT *
 --FROM Company_Table
 Industry_Tracking as (             --i
 SELECT 
       ji.job_id,
       i.industry_id,
       i.industry_name
FROM industries i
LEFT JOIN Job_industries ji
ON i.industry_id = ji.industry_id
),
--SELECT *
--FROM Industry_Tracking
Skills_sets AS (                     --s
    SELECT 
          js.job_id,
          js.skill_abr AS job_skill_abr,
          sk.skill_abr AS skills_skill_abr,
          sk.skill_name
    FROM job_skills js
    LEFT JOIN Skills sk
        ON js.skill_abr = sk.skill_abr
),
--SELECT *
--FROM Skills_sets
Employee_posting as(                --p
SELECT 

      e.company_id as employee_company_id,
      e.employee_count,
      e.follower_count,
      e.time_recorded,
      p.job_id,
      p.company_name,
      p.title,
      p.max_salary,
      p.pay_period,
      p.[location] as Job_location,
      p.company_id,
      p.[views],
      p.med_salary,
      p.min_salary,
      p.formatted_work_type,
      p.applies,
      p.original_listed_time,
      p.remote_allowed,
      p.job_posting_url,
      p.application_url,
      p.application_type,
      p.expiry,
      p.closed_time,
      p.formatted_experience_level,
      p.skills_desc,
      p.listed_time,
      p.posting_domain,
      p.sponsored,
      p.work_type,
      p.currency,
      p.compensation_type,
      p.normalized_salary,
      p.zip_code,
      p.fips
FROM postings p
LEFT JOIN employee_counts e
    ON e.company_id = TRY_CONVERT(INT,TRY_CONVERT(DECIMAL(18,1), p.company_id))
),
--SELECT *
--FROM Employee_posting
Compensation_benefit_table as (       --cb
SELECT 
     s.salary_id,
     s.job_id,
     s.max_salary,
     s.med_salary,
     s.min_salary,
     s.pay_period,
     s.currency,
     s.compensation_type,
     b.inferred,
     b.[type]

FROM Salaries s
LEFT JOIN BENEFITS b
ON s.job_id = b.job_id
),
--SELECT *
--FROM Compensation_benefit_table
--------------------------------------------------------------------------------
--Bring all the actual information you need to apear in the final table from their seprate cte processes
--IN THIS FINAL TABLE, Please and please ensure that every information you are briging down needs to have ONE alias like 's'
--Ensure they all have their various TIES in their respective CTEs/processes created. like ' job_id,Customer_id and more.
--When bring datas that has the 'AS' please bring the Alias in not the actual name ..eg Company_id AS Comp_id.
--Make sure the names in the final table does not appear twice either from any table ..(just once in the final table no mattter the Alias)

LINKEDIN_POSTING_SUMMARY AS
(
SELECT distinct
        -- Employee_posting table  p
        p.job_id,
        p.title,
        p.Job_location,
        p.[views],
        p.min_salary,
        p.formatted_work_type,
        p.original_listed_time,
        p.application_type,
        p.expiry,
        p.sponsored,
        p.work_type,
      
      -- from compensation table   cb
       cb.max_salary,
       cb.pay_period,
       cb.currency,
       cb.compensation_type,

     --From Skills_sets              s
       s.job_skill_abr,

    -- From Industry_Tracking         i
       i.industry_id,
       i.industry_name,


    -- From Company_Table AS          c
       c.[name],
       c.[description],
       c.company_size,
       c.[State],
       c.city,
       c.zip_code,
       c.country,
       c.industry,
       c.speciality
FROM Employee_posting p

LEFT JOIN Industry_Tracking i 
on p.job_id = i.job_id

LEFT JOIN Compensation_benefit_table cb
on p.job_id = cb.job_id

LEFT JOIN Company_Table c
on TRY_CONVERT(INT,TRY_CONVERT(DECIMAL(18,1), p.company_id)) = c.company_id

LEFT JOIN skills_sets s
ON p.job_id = s.job_id
)
select *
from LINKEDIN_POSTING_SUMMARY;



--FINAL TABLE UNARRANGED SO COLUMNS ARE UNARRANGED 

----------------------------------------------------------------------------------------------------------------------------

--HOW  TO CHECK THE DATA TYPE OF COLUMN AND TABLE NAME:
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN 
(
    'company_id',
    'job_id',
    'industry_id',
    'skill_abr'
)
ORDER BY TABLE_NAME, COLUMN_NAME;

-----------------------------------------------------------------------------------------------------------------------------
--TO KNOW THE EXACT DATATYPE YOU NEED FOR EACH COLUMN:

EXEC sp_help 'postings';

-----------------------------------------------------------------------------------------------------------------------------
--WHAT CAN MAKE A QUERY RUN EVEN FOR MORE THAN 30 MINS?

SELECT 
     fixed_drive_path,
     CAST(total_bytes/ 1073741824.0 as decimal(10,2)) as totalgb,
     CAST(available_bytes/1073741824.0 as decimal(10,2)) as freegb
FROM sys.dm_os_enumerate_fixed_drives

-----------------------------------------------------------------------------------------------------------------------------
--TO KNOW THE MATCHED AND UNMATCHED JOINS
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(b.employee_id) AS Matched_Rows,
    COUNT(*) - COUNT(b.employee_id) AS Unmatched_Rows
FROM Employees e
LEFT JOIN Benefits b
    ON e.employee_id = b.employee_id;

----------------------------------------------------------------------------------------------------------------------------
--This tells you how many rows actually matched.

LEFT JOIN → --keep EVERYTHING from the table on the LEFT.

RIGHT JOIN → --keep EVERYTHING from the table on the RIGHT.

FOR EXAMPLE:
  -------------
--Total_Rows       10,000
--Matched_Rows      7,500
--Unmatched_Rows    2,500

-----------------------------------------------------------------------------------------------------------------------------
--Creation of a dup_table_industry
   -------------------------------
Select * into Del_chk_industry
from industries;

select * 
from Del_chk_industry

BEGIN transaction;

with double_check as 
(
 SELECT *,
       ROW_NUMBER() OVER (PARTITION BY Industry_id ORDER BY industry_id Desc) as RN
FROM Del_chk_industry
)
Delete from double_check
Where RN > 1;

Rollback;

commit;

//** 
    🔴 Very important for your learning

Before doing DELETE operations in the future, use this pattern:

BEGIN TRANSACTION;

WITH Duplicate_check AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY industry_id
               ORDER BY industry_id
           ) AS RN
    FROM Del_chk_industry
)
DELETE FROM Duplicate_check
WHERE RN > 1;

-- Check your data first
SELECT *
FROM Del_chk_industry;

-- If everything is correct:
COMMIT;

-- If you made a mistake:
-- ROLLBACK;
**//




---------------------------------------------CHECK OUT 



--duplicate_check as
--(
--select *,
--      ROW_NUMBER()over(PARTITION by job_id order by work_type asc) as RN
--      From LINKEDIN_POSTING_SUMMARY
--      )
--      select *
--      from duplicate_check
--      where RN>1
--      ORDER BY job_id ASC;


WITH Company_Table AS
(
    SELECT
        co.Company_id,
        co.[name],
        co.[description],
        co.company_size,
        co.[State],
        co.city,
        co.zip_code,
        co.country,
        STRING_AGG(CAST(ci.industry AS varchar(MAX)), ',') AS industry,            -- Combine multiple industries into one column
        STRING_AGG(CAST(cs.speciality AS varchar(MAX)), ',') AS speciality         -- Combine multiple specialities into one column
    FROM Companies co
    LEFT JOIN Company_industries ci
    ON co.company_id = ci.company_id
    LEFT JOIN Company_specialities cs
    ON co.company_id = cs.company_id
    GROUP BY
        co.Company_id,
        co.[name],
        co.[description],
        co.company_size,
        co.[State],
        co.city,
        co.zip_code,
        co.country
),

Industry_Tracking AS
(
   SELECT
   ji.job_id,
   STRING_AGG(CAST(i.industry_id AS VARCHAR(Max)), ', ') AS industry_id,       -- Combine all industries belonging to the job
   STRING_AGG(CAST(i.industry_name AS varchar(MAX)), ',') AS industry_name
   FROM Job_industries ji
   LEFT JOIN industries i
   ON ji.industry_id = i.industry_id
   GROUP BY ji.job_id
),

Skills_sets AS
(
    SELECT
        js.job_id,
        STRING_AGG(CAST(sk.skill_name AS varchar(MAX)),',') AS skills         -- Combine all skills into one row
    FROM job_skills js
    LEFT JOIN Skills sk
    ON js.skill_abr = sk.skill_abr
    GROUP BY js.job_id
),

Employee_posting AS
(
    SELECT
        e.company_id AS employee_company_id,
        e.employee_count,
        e.follower_count,
        e.time_recorded,

        p.job_id,
        p.company_name,
        p.title,
        p.max_salary,
        p.pay_period,
        p.[location] AS Job_location,
        p.company_id,
        p.[views],
        p.med_salary,
        p.min_salary,
        p.formatted_work_type,
        p.applies,
        p.original_listed_time,
        p.remote_allowed,
        p.job_posting_url,
        p.application_url,
        p.application_type,
        p.expiry,
        p.closed_time,
        p.formatted_experience_level,
        p.skills_desc,
        p.listed_time,
        p.posting_domain,
        p.sponsored,
        p.work_type,
        p.currency,
        p.compensation_type,
        p.normalized_salary,
        p.zip_code,
        p.fips

    FROM postings p

    LEFT JOIN employee_counts e
        ON e.company_id =TRY_CONVERT(INT,TRY_CONVERT(DECIMAL(18,1),p.company_id))
),

Compensation_benefit_table AS
(
    SELECT
        s.job_id,
        STRING_AGG(CAST(s.max_salary AS VARCHAR(MAX)),',') AS max_salary,         -- If there are multiple salary records,
        STRING_AGG(CAST(s.med_salary AS VARCHAR(MAX)),',') AS med_salary,         -- choose one salary record for the job
        STRING_AGG(CAST(s.min_salary AS VARCHAR(MAX)),',') AS min_salary,

        STRING_AGG(CAST(s.pay_period AS VARCHAR(MAX)),',') AS pay_period,
        STRING_AGG(CAST(s.currency AS VARCHAR(MAX)),',') AS currency,
        STRING_AGG(CAST(s.compensation_type AS VARCHAR(MAX)),',') AS compensation_type
FROM Salaries s
GROUP BY s.job_id
),


LINKEDIN_POSTING_SUMMARY AS
(
    SELECT
        p.job_id,
        p.title,
        p.Job_location,
        p.[views],
        p.min_salary,
        p.formatted_work_type,
        p.original_listed_time,
        p.application_type,
        p.expiry,
        p.sponsored,
        p.work_type,

        -- Compensation
        cb.max_salary,
        cb.med_salary,
        cb.pay_period,
        cb.currency,
        cb.compensation_type,

        -- Skills
        s.skills,

        -- Industries
        i.industry_id,
        i.industry_name,

        -- Company
        c.[name],
        c.[description],
        c.company_size,
        c.[State],
        c.city,
        c.zip_code,
        c.country,
        c.industry,
        c.speciality

    FROM Employee_posting p

    LEFT JOIN Industry_Tracking i
        ON p.job_id = i.job_id

    LEFT JOIN Compensation_benefit_table cb
        ON p.job_id = cb.job_id

    LEFT JOIN Company_Table c 
    ON TRY_CONVERT(INT,TRY_CONVERT(DECIMAL(18,1),p.company_id)) = c.company_id

    LEFT JOIN Skills_sets s
        ON p.job_id = s.job_id
)
SELECT *
FROM LINKEDIN_POSTING_SUMMARY;