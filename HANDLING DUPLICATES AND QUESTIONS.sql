-- HANDLING DUPLICATE
--i) By creating a subquery nd inserting a Row Number 
--ii) Having Count,

select Job_id,
       Count(*) as Total_compamy
From postings
group by job_id
having count(*) >1  

--SUBQUERY------ TO CHECK THE NUMBER OF DUPLICATES .. MIND YOU WE DO NOT USE THIS TO DELETE DUPLIATE.
select 
       COUNT(*) as Duplicate_check
from 
(
select Job_id,
       Count(*) as Total_compamy
From postings
group by job_id
having count(*) >1  
) as DUPLICATE

--CTE
WITH DUPLICATE_CHECK AS
(
Select 
       *,
       ROW_NUMBER() OVER (PARTITION BY CLAIM_ID ORDER BY CLAIM_TYPE DESC) AS RN
       FROM Healthcaredata_SSIS
)
DELETE FROM DUPLICATE_CHECK
WHERE RN>1;
     
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TO CHECK THE DATATYOE OF A TABLE
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'postings'
  AND COLUMN_NAME = 'company_id';

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 --QUESTION:1 what is incremental load and the types of the SCD?
  /** INCREMENTAL LOAD : is the process of loading,inserting or updating new datas from the the source to the destination table.
                  SCD - SLOWLY CHANGING DIMENSION(information that describes something). 
                                             /\
                                             /\
                                             /\                                           : This simply means different ways of handling changes
                                             /\
   TYPE 1. (OVERWRITE): Which means I do not care about the old information just REPLACE with new information.(No historical information)                    FORGET HISTORY
   TYPE 2. (KEEP THE HISTORICAL RECORD): Here we do not delete the old record. we expire it and create a new row.(Keep all history)                          KEEP ALL HISTORY
   TYPE 3. (KEEP LIMITED HISTORY RECORD): Here, we only remember the previous value alone but not creating another row rather creating another column.       KEEP LIMITED HISTORY**/

   -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  /* QUESTION: 2 What is the different between the WHERE and OR clause?
     WHERE is used to filter datas looking for a paticular row while OR is used when you have to filter more than one condition and another true or acceptable condition.
     
     WHERE → Who do I want?
     OR    → This one OR that one?
     IN    → Is it in my list?
 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 /* QUESTION: 2 What is the different between the COUNT and SUM?
 
 COUNT() is an SQL aggregate function that returns the number of rows or non-NULL values in a specified column.

 SUM() is an SQL aggregate function that returns the total of all numeric values in a specified column.

 AVG() is an SQL aggregate function that calculates the arithmetic mean of the numeric values in a column.

 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 CONTROL FLOW: WHERE YOU BUILD AND CONTROL THE TASK THAT RUN.

 DATA FLOW: THIS IS WHERE YOU HANDLE THE ACTUAL MOVEMENT OF THE DATA. WHERE IS COMING FROM AND WHERE IT IS GOING TO

 Variable: A Temporary name contenance that stores value which can be ref later

 PARAMETERS. ARE VALUES THAT ARE STORED IN THE PARAMETER 

 EVENT HANDLER : A PROCESS GOING ON WHICH IS BEEN MONITORED AND HOW IT IS EXECUTING. DETAILS OF WHAT HAPPENED IN THE PACKAGE 

 PACKAGE EXPLORER: GIVES YOU AN INSIGHT OF HOW AND THE MANING OF THE PACKAGE 

 first is 
 get your data from the data flow task and rename it

 execution task .. is where you clean up your tasks or perform sql operations 