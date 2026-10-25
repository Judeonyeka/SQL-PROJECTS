--Anythical Function/windows function to read.


/* MERGE: Merge is merge datas or records together. it is used to syncronize data between systems by this, 
the merge has three senerios:

1. New Records = Insert it
2. Existing records that change = Update it with the new record
3. Existing record that is the same = Do not delete it or tamper

INCREAMENTAL LOAD:This means that you only process row data that changed since the last run so instead of 
reloading the entire data, we only load new records.

SCD = Slowly changing dimenssion
we have three mian types of SCD

Type 1: means override existing record : We can achive this, using the UPDATE FUNCTION

EXAMPLE:   UPDATE Employee_Type1
           SET Salary = 60000
           WHERE Employee_ID = 101;

Type 2: Means Keep historical record :   Here, every version of the previous records matters instead of overriding , 
                                         keep it but expire the old row and insert the new row using the Flags

Type 3: Keep Limited historical record:  Here, Every version matters like type 2. insted of creating new rows,it will
                                         create an extra colum in the existing column to track previous values/changes
                                         using the Date flag. It's limited because no aditional row is created */

--Sample Data.

--Source_TABLE
DROP TABLE IF exists SRC_EMPLOYEES
CREATE TABLE SRC_EMPLOYEES (
Emp_id int,
Emp_name Varchar (50),
Department Varchar (20),
Salary mONey,
Load_date Date
)
INSERT INTO SRC_EMPLOYEES
(Emp_id,Emp_name,Department,Salary,Load_date)
VALUES
--(101,'Jude ONyeka','Finance',52000,'06/20/2026'),
(102,'Kemi Ola','HOD FINANCE',85000,'06/20/2026'),
(104,'Emmanuel E','HR',50000,'06/20/2026')

-- DimensiON TABLE
CREATE TABLE DMI_EMPLOYEES_BACKUP (
Emp_id int,
Emp_name Varchar (50),
Department Varchar (20),
Salary mONey,
Last_updated_date Date
)
INSERT INTO DMI_EMPLOYEES_BACKUP
(Emp_id,Emp_name,Department,Salary,Last_updated_date)
VALUES
(101,'Jude ONyeka','Finance',5000,'06/20/2025'),
(102,'Kemi Ola','Accounting',8000,'06/20/2025'),
(103,'Jerry Osim','IT',10000,'06/20/2025')


SELECT *
FROM SRC_EMPLOYEES

SELECT *
FROM DMI_EMPLOYEES

SELECT *
FROM DMI_EMPLOYEES_BACKUP

--SCD Type 1/merge
MERGE INTO DMI_EMPLOYEES as t
USING SRC_EMPLOYEES as s
ON t.emp_id = s.emp_id
WHEN matched THEN
UPDATE SET
t.emp_name = s.emp_name,
t.department = s.department,
t.salary = s.salary,
t.Last_updated_date = s.load_date
WHEN not matched THEN
INSERT (Emp_id,Emp_name,Department,Salary,Last_updated_date)
VALUES
(s.Emp_id,s.Emp_name,s.Department,s.Salary,s.Load_date);

SELECT *
FROM (SELECT *,
     Row_number()over(PartitiON by emp_id order by load_date desc)rn 
     FROM SRC_EMPLOYEES
)x
WHERE rn > 1


With SRC_DEDUP as (
SELECT *
FROM (SELECT *,
     Row_number()over(PartitiON by emp_id order by load_date desc)rn 
     FROM SRC_EMPLOYEES
)x
WHERE rn > 1
)

MERGE INTO DMI_EMPLOYEES as t
USING SRC_DEDUP as s
ON t.emp_id = s.emp_id
WHEN matched THEN
UPDATE SET
t.emp_name = s.emp_name,
t.department = s.department,
t.salary = s.salary,
t.Last_updated_date = s.load_date
WHEN not matched THEN
INSERT (Emp_id,Emp_name,Department,Salary,Last_updated_date)
VALUES
(s.Emp_id,s.Emp_name,s.Department,s.Salary,s.Load_date);

--Type SCD 2
Drop TABLE DIM_EMPLOYEES_TYPE2
CREATE TABLE DIM_EMPLOYEES_TYPE2 (
Emp_id int,
Emp_name Varchar (50),
Department Varchar (20),
Salary mONey,
Effective_date Date,
End_date Date,
Is_current bit,
Load_date Date
)
INSERT INTO DIM_EMPLOYEES_TYPE2
(Emp_id,Emp_name,Department,Salary,Effective_date,End_date,Is_current,Load_date)
VALUES
(101,'Jude ONyeka','Finance',5000,'06/20/2025','01/30/2028','1','06/20/2025'),
(102,'Kemi Ola','Accounting',8000,'06/20/2025','02/28/2028','1','06/20/2025'),
(103,'Jerry Osim','IT',10000,'06/20/2025','04/30/2028','1','06/20/2025')


With SRC_DEDUP as (
SELECT *
FROM (SELECT *,
     Row_number()over(PartitiON by emp_id order by load_date desc)rn 
     FROM SRC_EMPLOYEES
)x
WHERE rn > 1
)

MERGE INTO DIM_EMPLOYEES_TYPE2 AS t
USING (
SELECT
s.emp_id,
s.emp_name,
s.department,
s.salary
FROM SRC_DEDUP as s
)s
ON t.emp_id = s.emp_id
AND t.is_current = '1' 

WHEN MATCHED 
AND (t.emp_name <> s.emp_name
OR t.department <> s.department
OR t.salary <> s.salary
)
THEN 
UPDATE SET
t.End_date = DATEADD(DAY,-1,TRY_CAST(GETDATE() AS Date)),
t.Is_current = '0'

WHEN NOT MATCHED THEN
INSERT (Emp_id,Emp_name,Department,Salary,Effective_date,End_date,Is_current,Load_date)
VALUES (
s.emp_id,
s.emp_name,
s.department,
s.salary,
TRY_CAST(GETDATE() AS Date),
'01/07/2029',
'1',
TRY_CAST(GETDATE() AS Date)
);

SELECT *
FROM DIM_EMPLOYEES_TYPE2

--SCD Type 3 DIM TABLE

DROP TABLE IF exists DMI_EMPLOYEES_TYPE3
CREATE TABLE DMI_EMPLOYEES_TYPE3 (
Emp_id int,
Emp_name Varchar (50),
Department Varchar (20),
Salary mONey,
Previous_department Varchar(50)null,
Previous_salary mONey,
Department_change_date Date,
Salary_change_date date,
Last_updated_date Date
)
INSERT INTO DMI_EMPLOYEES_TYPE3
(
Emp_id,
Emp_name,
Department,
Salary,
Previous_department,
Previous_salary,
Department_change_date,
Salary_change_date,
Last_updated_date
)
VALUES
(101,'Jude ONyeka','Finance',5000,Null,Null,Null,Null,'06/20/2025'),
(102,'Kemi Ola','Accounting',8000,Null,Null,Null,Null,'06/20/2025'),
(103,'Jerry Osim','IT',10000,Null,Null,Null,Null,'06/20/2025')


SELECT * 
FROM SRC_EMPLOYEES

SELECT * 
FROM DMI_EMPLOYEES_TYPE3


--SCD Merge Type 3 Query
MERGE INTO DMI_EMPLOYEES_TYPE3 as t
USING SRC_EMPLOYEES as s
ON t.Emp_id = s.Emp_id
WHEN MATCHED THEN
UPDATE SET
t.Previous_department = CASE WHEN t.department <> s.department THEN t.department     --<> means NOT IN
ELSE Previous_Department 
END,
t.Previous_salary = CASE WHEN t.salary <> s.salary THEN t.salary
ELSE Previous_salary
END,
t.Department_change_date = CASE WHEN t.department <> s.department THEN s.Load_date
ELSE t.Department_change_date
END,
t.Salary_change_date = CASE WHEN t.Salary <> s.salary THEN s.Load_date
ELSE t.Salary_change_date
END,
t.Emp_name = s.Emp_name,
t.Department = s.Department,
t.Salary = s.Salary,
t.last_updated_date = s.Load_date
WHEN NOT MATCHED THEN
INSERT
(
Emp_id,
Emp_name,
Department,
Salary,
Previous_department,
Previous_salary,
Department_change_date,
Salary_change_date,
Last_updated_date
)
VALUES
(
s.Emp_id,
s.Emp_name,
s.Department,
s.Salary,
Null,
Null,
Null,
Null,
s.Load_date
);

/* INCREAMENTAL LOAD IS A CONCEPT OF EFFICIENCY JUST LIKE CIA IN CYBER-SECURITY WHICH CAN LEAD TO THE LOASS OF LIFE. THERE FORE MAKING DATA AVAIBALBE TO MY CONSUMERS IS MY PRIOTIY 
THEREFORE PROCESSES THAT TAKES 2 HRS TO RUN I MANAGE IT IN 30 MINS AND IT HAS A GREATE INTEGRITY.*/

-- CREATING A STAGING TABLE: This TABLE ONly cONtains Records modified since the last load.

CREATE TABLE stg_TME_sales (
       Sales_id int,
       Customer_id int,
       Amount mONey,
       Sales_date date,
       Load_date date
)
INSERT INTO stg_TME_sales
(Sales_id,Customer_id,Amount,Sales_date,Load_date)
VALUES
(1,101,1000,'2025-06-01','2025-06-01'),
(2,102,11000,'2025-07-03','2025-07-03'),
(3,103,14000,'2025-04-05','2025-04-05'),
(4,104,5500,'2025-02-03','2025-02-03')


SELECT *
FROM stg_TME_sales

SELECT * into stg_TME_sales2
FROM stg_TME_sales

CREATE TABLE dim_TME_sales (
       Sales_id int Primary key,
       Customer_id int,
       Amount mONey,
       Sales_date date,
       Last_updated date
)

--MERGE FOR INCREAMENTAL LOAD
--Trying to Load data FROM a stage enviroment to a destinatiON 

With Stg_dedup as (        
SELECT 
      Sales_id,
      Customer_id,
      Amount,
      Sales_date,
      Load_date,
      Row_Number()Over(partitiON by Customer_id order by Load_date desc) as RN
      FROM Stg_TME_sales
      )
--Merge Query
MERGE INTO dim_TME_sales t
USING ( 
SELECT 
      Sales_id,
      Customer_id,
      Amount,
      Sales_date,
      Load_date
FROM Stg_dedup
WHERE  RN = '1'
)s
ON t.Customer_id = s.customer_id
And t.Sales_id = s.sales_id
WHEN matched THEN
UPDATE SET 
--t.customer_id = s.customer_id,
t.Amount =s. Amount,
t.Sales_date = s.Sales_date,
t.Last_updated = s.Load_date
WHEN NOT MATCHED THEN
INSERT (Sales_id,Customer_id,Amount,Sales_date,Last_updated)
VALUES (s.Sales_id,s.Customer_id,s.Amount,s.Sales_date,s.Load_date);

SELECT *
FROM dim_TME_sales

------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM Healthcare_Date

-- ETL therefore is the extraction of information from different sources, tranforming them through data cleaning and filterings and thereabout loading them into a destiation system like Data warehouse


                                            --PROJECT__
-->CREATE A staging table from medical condition
-->Create a unique table for each medical condition
-->Create an incremental load process that loads each of those tables to one final destination the destination table should be called ETL_healthcare_data

--NAME: JUDE ONYEKA
--PROJECT: 
--DATE:06/27/2026

--(i)
SELECT * INTO stg_Cancer
FROM Healthcare_Date
WHERE 1= 1 -----Creating all information in the table.
And Medical_Condition ='cancer'

SELECT *
FROM stg_Cancer
----------------------------------
SELECT * INTO stg_Diabetes
FROM Healthcare_Date
WHERE 1 = 1
and medical_condition = 'Diabetes'

SELECT *
FROM stg_Diabetes
----------------------------------
SELECT * INTO stg_Arthritis
FROM Healthcare_Date
WHERE 1 = 1
and Medical_Condition = 'Arthritis'

SELECT * 
FROM stg_Arthritis
----------------------------------

SELECT * INTO stg_Asthma
FROM Healthcare_Date
WHERE 1 =1 
And Medical_Condition = 'Asthma'

SELECT *
FROM stg_Asthma
----------------------------------

SELECT * INTO stg_Hypertension
FROM Healthcare_Date
WHERE 1 = 1
And Medical_Condition = 'Hypertension'

SELECT * 
FROM stg_Hyp ertension
----------------------------------

SELECT * INTO stg_Obesity
FROM Healthcare_Date
WHERE 1 = 1
And Medical_Condition = 'Obesity'

SELECT * 
FROM stg_Obesity
----------------------------------

--First step: we need to create a Destination Table 

 select *
 from Healthcare_Date


