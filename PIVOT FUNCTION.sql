
--PIVOT Transpose rows into columns. We use PIVOT for several cases.

SELECT *
FROM Healthcare_Date

SELECT DISTINCT Medical_condition
FROM Healthcare_Date
Diabetes
Cancer
Arthritis
Asthma
Hypertension
Obesity


/*We are trying to transpose medical_conditions to get the overall sum of billing of each medical condition from our heakthcare data. 
This is useful to leadership to determine the medical condition that brings more revenue to the industry and same with the insurance company*/

SELECT *
FROM (
      SELECT insurance_provider,   -- Use the First Sub_query to identify or filter the information we need to transpose.
             Medical_condition,
             Billing_amount
FROM Healthcare_Date
)X
PIVOT
     (
     SUM(Billing_amount)
     FOR Medical_condition
     IN (
         [Diabetes],
         [Cancer],            --[] Reasons- Treating the conditions as columns,
         [Arthritis],
         [Asthma],
         [Hypertension],
         [Obesity]
)
)Y  

--We are trying to analyse how many admission_type based on their medical conditions
SELECT DISTINCT Admission_Type
FROM Healthcare_Date
--Emergency
--Urgent
--Elective

CREATE VIEW VW_Med_Cond_Admin_type AS  -- Creating the View
SELECT *
FROM (
      SELECT Admission_type,
             Medical_condition
FROM Healthcare_Date
)x
PIVOT
    (
    COUNT(Admission_type)
    FOR Admission_type
    in 
    (
    [Emergency],
    [Urgent],
    [Elective]
)
)y


SELECT *
FROM VW_Med_Cond_Admin_type

--SELECT THE HIGHEST ADMISSION TYPE BY MEDICAL_CONDITION


SELECT MEDICAL_CONDITION,
       MAX([Emergency]) as [Highest_Emergency],
       MAX(Urgent) as [Highest_Urgent],
       MAX(Elective) as [Highest_Elective]
FROM VW_Med_Cond_Admin_type
GROUP BY MEDICAL_CONDITION;


--CTE
WITH MAX_MED_CONDITION AS
(
SELECT*
FROM VW_Med_Cond_Admin_type
)
SELECT *
FROM (
SELECT TOP 1
MEDICAL_CONDITION,
[Emergency] as HIGHEST_COUNT,
'EMERGENCY' as ADMISSION_TYPE
FROM MAX_MED_CONDITION
ORDER BY [EMERGENCY] DESC
)EMERGNECY_MAX

UNION ALL

SELECT*
FROM (
SELECT TOP 1
MEDICAL_CONDITION,
URGENT AS HIGHEST_COUNT,
'URGENT' as ADMISSION_TYPE
FROM MAX_MED_CONDITION
ORDER BY [URGENT] DESC
)URGENT_MAX

UNION ALL

SELECT *
FROM (
SELECT TOP 1
MEDICAL_CONDITION,
ELECTIVE AS HIGHEST_COUNT,
'ELECTIVE' AS ADMISSION_TYPE
FROM MAX_MED_CONDITION
ORDER BY [ELECTIVE] DESC
)ELECTIVE_MAX;

