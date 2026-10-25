
create database Healthcare_dev

Use Healthcare_dev

--Using bulk insert to load data into Healthcare_dev

Drop table if exists Claim_adjustments 
--CLAIM ADJUSTMENT
Create Table Claim_adjustments (
Claim_id varchar(20)  null,
line_num varchar(20) null,
adjustment_group varchar(20) null,
adjustment_code varchar(20) null,
adjustment_amount money null,
remark_code varchar(50) null
)

--Bulk Insert
Bulk insert claim_adjustments
from 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\Claim_adjustments.csv'
with
(
format = 'csv', firstrow = 2,
fieldterminator =',',
rowterminator ='0x0a'
)

select *
from Claim_adjustments


Drop table if exists Claim_denials 
--CLAIM DENIALS
Create Table claim_denials (
Claim_id varchar(20)  null,
line_num varchar(20) null,
denial_reason varchar(20) null,
denial_status varchar(20) null,
denial_amount money null,
)

Bulk insert claim_denials
from 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\claim_denials.csv'
with
(
format = 'csv',
firstrow = 2,
fieldterminator =',',
rowterminator ='0x0a'
)

select *
from Claim_denials


--CLAIM_HEADER
Drop table if exists claim_header
Create table claim_header (
Claim_id varchar(20)null,
member_id varchar(20)null,
provider_id varchar(20)null,
service_date varchar(20)null,
claim_type varchar(20),
state varchar(20),
allowed_amount money,
paid_amount money,
dx_code varchar(20)null
)

Bulk insert claim_header
From 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\claim_header.csv'
with
(
format ='csv',
firstrow = 2,
fieldterminator =',',
rowterminator ='0x0a'
)

Select *
from Claim_header

--CLAIM LINES
Create Table claim_lines( 
claim_id int,
line_num int,
place_of_service varchar(20),
proc_code bigint,
dx_code varchar(20),
units varchar(20),
charge_amount money,
allowed_amount money,
paid_amount money,
denial_reason varchar(20),
ndc_code bigint
)

Bulk insert claim_lines
From 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\claim_lines.csv'
with
(
format = 'csv',
firstrow = 2,
fieldterminator = ',',
rowterminator = '0x0a'
)

Select *
from claim_lines

--CLAIMS
drop table if exists claims
Create Table Claims (
claim_id int,
member_id int,
provider_id int,
service_date date,
claim_type varchar(20),
state varchar(20),
allowed_amount Money,
paid_amount Money,
dx_code varchar(20)
)

Bulk insert Claims
From 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\claims.csv'
with
(
Format = 'csv',
firstrow = 2,
fieldterminator = ',',
rowterminator = '0x0a'
)

select *
from Claims

-- DIAGNOSIS_DIM

Create Table Diagnosis_dim(
dx_code varchar(20),
dx_description varchar(20),
dx_chapter varchar(20)
)

Alter table diagnosis_dim
Alter column dx_description varchar(30)

Bulk Insert Diagnosis_dim
from 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\Diagnosis_dim.csv'
with
(
Format = 'csv',
Firstrow = 2,
Fieldterminator = ',',
rowterminator = '0x0a'
)

select *
from Diagnosis_dim

--ELIGIBILITY

Drop table if exists Eligibility
Create table Eligibility(
member_id int,
payer_id int,
payer_name varchar(20),
plan_type varchar(20),
coverage_start date,
coverage_end date,
coverage_status varchar(20)
)

Bulk insert Eligibility
from 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\Eligibility.csv'
with 
(
Format = 'csv',
firstrow = 2,
fieldterminator = ',',
rowterminator = '0x0a'
)

select *
from Eligibility


--MEMBERS

Create Table Members(
member_id int,
first_name varchar(20),
last_name varchar(20),
dob Date,
gender varchar(20),
state varchar(20),
zip3 int,
payer varchar(20),
plan_type varchar(20)
)

Bulk insert Members
From 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\Members.csv'
with 
(
Format = 'csv',
firstrow = 2,
fieldterminator = ',',
rowterminator = '0x0a'
)

select *
from Members


--PAYER_DIM
drop table if exists Payer_dim
Create table Payer_dim(
payer_id int,
payer_name varchar(20),
payer_type varchar(20),
payer_region varchar(20),
contact_email varchar(20)
)

Alter table payer_dim
Alter column contact_email varchar(40)

Alter table Payer_dim
Alter column payer_type varchar(40)


Bulk insert Payer_dim
from 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\payer_dim.csv'
with
(
Format = 'csv',
firstrow = 2,
fieldterminator = ',',
rowterminator = '0x0a'
)

select *
from Payer_dim

--PROCEDURE_DIM

Create Table Procedure_dim (
proc_code int,
proc_description varchar(20),
proc_group varchar(20)
)

Alter table procedure_dim
Alter Column proc_description varchar(50)


Bulk insert Procedure_dim
from 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\procedure_dim.csv'
with
(
Format = 'csv',
firstrow = 2,
fieldterminator = ',',
rowterminator = '0x0a'
)

select *
from Procedure_dim


--PROVIDERS

Create Table Providers(
provider_id int,
provider_name varchar(20),
specialty varchar(20),
state Varchar(10),
npi bigint,
years_experience int
)

Bulk insert Providers
From 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\Providers.csv'
with
(
Format = 'csv',
firstrow = 2,
fieldterminator = ',',
rowterminator = '0x0a'
)

Select *
from Providers

--PROVIDERS_FROM_CLAIMS 

Drop Table if exists Providers_from_claims
Create Table Providers_from_claims(
provider_id int,
provider_name varchar(30),
specialty varchar(30),
state varchar(20),
npi varchar(30),
years_experience int
)


BULK INSERT Providers_from_claims
FROM 'C:\Users\jonye\Desktop\SQL Classes\CLASSES MATERIALS\Healthcare_data\Providers_from_claims.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
);

Select *
from Providers_from_claims

use Healthcare_dev

 //* Shortcut for Importing Datas into SQL
 Windows key + R
 Paste DTSwizard.exe
 *//
 

 Select top(1) *
 From claim_header

 Select top(1) *
 From Members

 Select top(1) *
 From Providers

  --How to check for a Unique Value

  Select distinct Claim_type 
  from Claim_header


 --USING JOIN TO BUILD OUR CLAIM BASE FROM CLAIM_HEADERS,MEMBERS AND PROVIDERS. GIVING US A CLAIM BASE TABLE
 --WITH THIS, WE RE TRACKING THE CLAIMS,MEMBERS AND PROVIDER INFORMATION.

 SELECT
 h.claim_id,
 h.member_id,
 h.provider_id,
 h.service_date,
 h.claim_type,
 h.allowed_amount,
 h.paid_amount,
 m.[state],
 p.specialty
 From claim_header h
 Join Members m
      On h.member_id = m.member_id
Join providers p
     On h.provider_id = p.provider_id


--With CTE

 With Claims_base AS(
 SELECT
      h.claim_id,
      h.member_id,
      h.provider_id,
      h.service_date,
      h.claim_type,
      h.allowed_amount,
      h.paid_amount,
      m.[state],
      p.specialty
 From claim_header h
Join Members m
      On h.member_id = m.member_id
Join providers p
     On h.provider_id = p.provider_id
),
--Building medical_claim Dim
Medical_claims as(
Select 
      claim_id,
      member_id,
      provider_id,
      service_date,
      claim_type,
      allowed_amount,
      paid_amount,
      'medical' as claim_category
From Claims_base
where Claim_type in ('INSTITUTIONAL', 'PROFESSIONAL')
),
--Building claim Pharmacy
Pharmacy_claim as (
Select 
      claim_id,
      member_id,
      provider_id,
      service_date,
      claim_type,
      allowed_amount,
      paid_amount,
      'pharmacy' as claim_category
      From Claims_base 
      where Claim_type = 'pharmacy'
),
--Bringing all claims data to one final claims dim.
All_claims as (
Select *
From Medical_claims

Union all

Select *
From Pharmacy_claim
),
--building Claim status
Claim_status as (
Select 
      claim_id,
      member_id,
      provider_id,
      claim_category,
      service_date,
      Case
      when paid_amount = 0 then 'denied'
      when paid_amount < allowed_amount then 'Partial Paid'
      Else 'Fully Paid'
      End as Payment_status,
      Paid_amount,
      allowed_amount
 From All_claims
      ),
 -- Build a claim Financial
      Financial as (
Select 
      c.claim_id,
      c.member_id,
      c.provider_id,
      c.claim_category,
      c.paid_amount,
      c.allowed_amount,
      COALESCE(d.denial_amount, 0) as denied_amount,
      COALESCE(a.adjustment_amount, 0) as adjustment_amount
From claim_status c
Left join[dbo].[claim_denials] d
     on c.claim_id = d.claim_id
Left join [dbo].[Claim_adjustments] a
     On c.claim_id = a.claim_id
)
Select 
     Provider_id,
     claim_category,
count(distinct claim_id) as total_claim,
sum(paid_amount) as total_paid,
sum(denied_amount) total_denied,
sum(adjustment_amount) Total_ADJUSTMENT,
avg(paid_amount) avg_paid,
case
when sum(denied_amount) > 500 then 'High denial provider'
when sum(paid_amount) > 20000 then 'High cost provider'
else 'Normal'
End Provider_Flag 
From Financial 
Group by provider_id,claim_category
),



--.............................................................................
CREATE or alter VIEW vw_CTE_HealthCare_Summary AS 
--With CTE 
WITH Claims_base AS(
    SELECT
        h.claim_id,
        h.member_id,
        h.provider_id,
        h.service_date,
        h.claim_type,
        h.allowed_amount,
        h.paid_amount,
        m.[state],
        p.specialty
    FROM claim_header h
    JOIN Members m
        ON h.member_id = m.member_id
    JOIN providers p
        ON h.provider_id = p.provider_id
),

Medical_claims AS(
    SELECT 
        claim_id,
        member_id,
        provider_id,
        service_date,
        claim_type,
        allowed_amount,
        paid_amount,
        'medical' AS claim_category
    FROM Claims_base
    WHERE claim_type IN ('INSTITUTIONAL', 'PROFESSIONAL')
),

Pharmacy_claim AS (
    SELECT 
        claim_id,
        member_id,
        provider_id,
        service_date,
        claim_type,
        allowed_amount,
        paid_amount,
        'pharmacy' AS claim_category
    FROM Claims_base 
    WHERE claim_type = 'pharmacy'
),

All_claims AS (
    SELECT * FROM Medical_claims
    UNION ALL
    SELECT * FROM Pharmacy_claim
),

Claim_status AS (
    SELECT 
        claim_id,
        member_id,
        provider_id,
        claim_category,
        service_date,
        CASE
            WHEN paid_amount = 0 THEN 'denied'
            WHEN paid_amount < allowed_amount THEN 'Partial Paid'
            ELSE 'Fully Paid'
        END AS Payment_status,
        paid_amount,
        allowed_amount
    FROM All_claims
),
--Building Financa_Claim
Financial AS (
    SELECT 
        c.claim_id,
        c.member_id,
        c.provider_id,
        c.claim_category,
        c.paid_amount,
        c.allowed_amount,
        COALESCE(d.denial_amount, 0) AS denied_amount,
        COALESCE(a.adjustment_amount, 0) AS adjustment_amount
    FROM Claim_status c
    LEFT JOIN [dbo].[claim_denials] d
        ON c.claim_id = d.claim_id
    LEFT JOIN [dbo].[Claim_adjustments] a
        ON c.claim_id = a.claim_id
),
--Building Provider_summary
Provider_summary AS (
    SELECT 
        provider_id,
        claim_category,
        member_id,
        COUNT(DISTINCT claim_id) AS total_claim,
        SUM(paid_amount) AS total_paid,
        SUM(denied_amount) AS total_denied,
        SUM(adjustment_amount) AS total_adjustment,
        AVG(paid_amount) AS avg_paid,
        CASE
            WHEN SUM(denied_amount) > 500 THEN 'High denial provider'
            WHEN SUM(paid_amount) > 20000 THEN 'High cost provider'
            ELSE 'Normal'
        END AS provider_flag
    FROM Financial 
    GROUP BY provider_id, claim_category, member_id
),
--Building claims and records of services who are Eligible. 
Claim_Eligibility AS (
    SELECT 
        member_id,
        payer_id,
        payer_name,
        plan_type,
        coverage_start,
        coverage_end,
        coverage_status,
        CASE
            WHEN coverage_status = 'Active' THEN 'Eligible'
            Else  'Non_Eligible'
            
        END AS Eligibility_tracker
    FROM [dbo].[Eligibility]
)
--final output table 
Select distinct
--Coming from Member 
--NORMALIZING MEMBER NAME TO EXCULDE _+ NUMBER AND CONCATING FIRST NAME AND LAST NAME AS ONE MEMBER NAME 
Concat(Left(m.first_name, CHARINDEX('_', First_name) -1),' ',
LEFT(m.Last_name, Charindex('_', Last_name) - 1)) as Member_name,
m.gender,
m.[state],
-- coming from Claim base
c.claim_id,
c.provider_id,
-- coming from Eligibility
e.member_id,
e.payer_id,
e.payer_name,
e.plan_type,
e.coverage_start,
e.coverage_end,
e.coverage_status,
e.eligibility_tracker,
--coming from Provider summary
p.claim_category, 
p.total_claim,
P.Total_paid + p.total_denied as Total_ServiceCost,
p.total_paid,
p.total_denied,
p.total_adjustment,
p.avg_paid,
p.provider_flag, 
--Coming from Financial
c.paid_amount,
c.allowed_amount
FROM [dbo].[Members] m
inner join Claims_base c
on m.member_id = c.member_id
left join Claim_Eligibility e
on m.member_id = e.member_Id
LEFT JOIN Provider_summary p
on m.member_id = p.member_id
where e.coverage_status = 'Active'




--NUMBER OF PLAN TYPE 
Select plan_type, 
       count(*) Totalplantype,
       sum(total_denied) ClaimDenied,
       sum(total_claim) TotalClaim
from  vw_CTE_HealthCare_Summary
group by plan_type
order by ClaimDenied desc


--             ASSIGNMENT.
-- Total numbers of each gender 
-- Return the higest payer by name and type 
-- Check the oldest coverage_end date 
-- Check member deinal rate 
-- Return only memebers with no claim deinal
-- Give a total finacial impact of all claim and denail rate 
-- Create a condional expression to evalute member reason of dinal 
-- Hightlight what is driving claim cost 

--CTE View
vw_CTE_HealthCare_Summary


Select * 
From vw_CTE_HealthCare_Summary


SELECT TOP 1 m.*
FROM vw_CTE_HealthCare_Summary m 
order by 2 desc

-- Where plan type is PPO

select Plan_type, sum(payer_id) as Total_payers
From vw_CTE_HealthCare_Summary
where plan_type = 'ppo'
group by plan_type

-- Total numbers of each gender 
Select Gender, count (*) as Total_Gender  
from vw_CTE_HealthCare_Summary
where gender in ('M','F')
group by gender

--Return the highest payer by name and type 
Select Top 1 Payer_name, Plan_type, 
       Sum(total_paid) as Highest_Payername
from vw_CTE_HealthCare_Summary
Group by Payer_name, Plan_type
Order by Highest_Payername Desc

-- Second Option
-- (The Inner query produces the result that the outer query filters from)
Select Top 1 * --outer query
From 
(
Select Payer_name, Plan_type, --inner query
       Sum(total_paid) as Highest_Payername
from vw_CTE_HealthCare_Summary
Group by Payer_name, Plan_type
)x
Order by Highest_Payername Desc



--Check the oldest coverage_end date
Select min(coverage_end) as Oldest_coverage_end_date
From vw_CTE_HealthCare_Summary

--Check the newest coverage_end date
Select max(coverage_end) as Oldest_coverage_end_date
From vw_CTE_HealthCare_Summary

--Check member deinal rate
select Member_name,gender,
       Sum(total_denied) As Denial_rate
From vw_CTE_HealthCare_Summary
group by Member_name,gender

--Retrun only memebers with no claim deinal
Select Claim_id,Member_name,gender
From vw_CTE_HealthCare_Summary
where total_denied is Null

--Since the Total_denied is stored as amount, we then have to make use of the COALESCE Fucntion

--Using the coalesce to return members with no claim_denial

Select Claim_id,member_name,gender,total_denied
From vw_CTE_HealthCare_Summary
where Coalesce (total_denied,0) = 0
group by Claim_id,member_name,gender,total_denied

Select *
From vw_CTE_HealthCare_Summary
where Coalesce (total_denied,0) = 0

--Give a total finacial impact of all claim and denial_rate
Select 
      Claim_id,claim_category,Member_name,payer_name,plan_type,
      Sum(total_claim) as Total_Finacial_claim,
      Sum(total_paid) as Total_Finacial_money_paid,
      Sum(total_denied) as Total_financial_claim_denied,
      Sum(total_adjustment) as Total_finacial_adjustment,
      Sum(avg_paid) as Total_no_of_avg_claim_paid      
From vw_CTE_healthcare_summary
Group by Claim_id,claim_category,Member_name,payer_name,plan_type

--Create a condional expression to evalute member reason of denial.
//*
-Here we re going to report a conditonal or a case statement to return data stating the reason behind the member's denial 
-Therefore,we need to find the best criteria to ascertain denial and allowed which is = 'Provider_flag'
-Since we re working on members, we need to also clasify this members with their names and ID to enable us group our result from the 
conditional statement reported.
*/
--Select *
--From vw_CTE_HealthCare_Summary
--where member_id = '165319'

SELECT 
decision_status,
COUNT(*) AS TOTALCOUNT,
SUM(Total_financial_claim_denied) AS Total_financial_claim_denied,
SUM(Total_allowed_amount) AS Total_allowed_amount,
SUM(Totalservicecost) AS Totalservicecost
FROM    
(
SELECT 
    member_id,
    Member_name,
    provider_flag,
    SUM(total_denied) AS Total_financial_claim_denied,
    SUM(allowed_amount) AS Total_allowed_amount,
    sum(total_servicecost) as Totalservicecost,
    CASE
        --WHEN provider_flag = 'Normal' THEN 'Allow'
        WHEN provider_flag = 'High denial provider'  then 'Member Max insured approved amount and provider has high cost services'
        WHEN provider_flag = 'NORMAL' 
        AND Total_ServiceCost > allowed_amount
        AND total_denied > 1
        THEN 'Member Max insured approved amount'
        WHEN provider_flag = 'NORMAL' 
        AND Total_ServiceCost < allowed_amount
        AND total_denied > 1
        THEN 'Provider is not taking insurance for the service'
        ELse 'Fully_paid '
    END AS decision_status

FROM [dbo].[vw_CTE_HealthCare_Summary]
GROUP BY member_id,Member_name,provider_flag, Total_ServiceCost, allowed_amount, total_denied
 )X  
 WHERE decision_status <> 'FULLY_PAID'
GROUP BY decision_status



--Hightlight what is driving claim cost ?????



Select * 
From vw_CTE_HealthCare_Summary