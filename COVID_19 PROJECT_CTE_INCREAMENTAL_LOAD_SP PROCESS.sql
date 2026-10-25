--NAME:ONYEKA JUDE
--PROJECT:BULK INSERT
--DATE:07/15/2026

-- Use the Bulk insert as your 'stagging' to run the increamental load concept ensuring your handling duplicates by adding load date.

-- Use Increamental Load to load these data to a destination table 'covid_19_data_sets'

/*                                             INCREAMENTAL LOAD: 
i)    Create database
ii)   Create a staging source table 
iii)  Create a stagging dimention table
iv)   Alter any Column if need be 
v)    Create the store procedure to be able to collect all the statement for an easy execution.
vi)   Store Procedure
Vii)  Truncating the table - clearing ay available data leaving the structure for new datasets
viii) Inserting Data into the source from the Raw file data
ix)   Create a CTE to dedup(duplicate) and to add the Row_number
x)    Merging statment (inserting/match and not matched)

                                          CTE-(COMMON TABLE EXPRESSION)-VIRTUAL TABLE

*/
CREATE DATABASE Covid_19

-- Bulk Inserting Table from the Source File

CREATE TABLE Covid_19_data_set 
(
country varchar(50),
continent Varchar(50),
population Int null,
day Date,
time varchar(50),
Cases Int,
Recovered Int,
Deaths Int,
Tests Int
)

BULK INSERT Covid_19_data_set 
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Covid_19\covid_19.csv.csv'
with
(
FORMAT = 'csv', 
FIRSTROW = 2,
FIELDTERMINATOR =',',
ROWTERMINATOR ='0x0a'
);

SELECT *
FROM Covid_19_data_set 
---------------------------------------------------------------------------------------------------------------
-- Creation of my (SOURCE TABLE) including the loading date which helps to handle the duplicates.

SELECT *
INTO Stg_ETL_Covid_19
FROM Covid_19_data_set
WHERE 1=0;  -- Leaving the structure                                                                            

------------------------------------------------------------------------------------------------------
-- Creation of my Dimension Table (FINAL DESTINATION TABLE)

SELECT *
INTO DIM_Stg_ETL_Covid_19
FROM Stg_ETL_Covid_19
WHERE 1=0

--  Here I will add a new column to handle duplicates.

ALTER TABLE Stg_ETL_Covid_19                                                       
ADD Load_date Datetime

--------------------------------------------------------------------------------------------------------------------

--STORE PROCEDURE

CREATE OR ALTER PROCEDURE SP_Load_ETL_Covid_19_data_set
AS
BEGIN

SET NOCOUNT ON;

TRUNCATE TABLE Stg_ETL_Covid_19;

INSERT INTO Stg_ETL_Covid_19 --Here,I'm inserting e (load date) & all data frm my original source e de stagging structure.
SELECT *, Getdate() 
FROM Covid_19_data_set;

-- Creating a CTE to DEDUP the stagging data 
WITH Stg_ETL_Covid_19_Dedup AS (
SELECT *,
ROW_NUMBER () OVER (PARTITION BY country ORDER BY Load_date DESC) AS RN
FROM Stg_ETL_Covid_19

)

MERGE INTO DIM_Stg_ETL_Covid_19 AS tgt
USING
(
SELECT *
FROM Stg_ETL_Covid_19_Dedup AS src
WHERE RN=1 --This simply means sql to return the LATEST RN/DATAS of each partition 
) AS src
On tgt.country = src.country
WHEN MATCHED THEN
UPDATE SET 
     tgt.[continent] = src.[continent],
     tgt.[population] = src.[population],
     tgt.[day] = src.[day],
     tgt.[time] = src.[time],
     tgt.[Cases] = src.[Cases],
     tgt.[Recovered] = src.[Recovered],
     tgt.[Deaths] = src.[Deaths],
     tgt.[Tests] = src.[Tests],
     tgt.load_date = Getdate()

     WHEN NOT MATCHED BY TARGET THEN
     INSERT (
       [country],
       [continent],
       [population],
       [day],
       [time],
       [Cases],
       [Recovered],
       [Deaths],
       [Tests],
       [Load_date]
       )
       VALUES
       (
       src.[country],
       src.[continent],
       src.[population],
       src.[day],
       src.[time],
       src.[Cases],
       src.[Recovered],
       src.[Deaths],
       src.[Tests],
       Getdate()
);
End

-- All in this gives us an insight of Automation scripts