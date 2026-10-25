
-- LINEAR REGRESSION:

--diff
--base call means agents daily call volume. 
--close rate = means each agent tru conversion

CREATE TABLE dbo.Agents(
Agent_id int Primary key,
Agent_name Varchar(50) null,
Team Varchar(20) null,
Base_calls Int null,
Close_rate Decimal(5,3) null
)

Insert Into dbo.Agents Values 
(101, 'Agent 01',    'Medicare', 120, 0.090),
(102, 'Agent 02',    'Medicare', 95, 0.110),
(103, 'Agent 03',    'Medicare', 130, 0.055),
(104, 'Agent 04',    'Medicare', 80, 0.085),
(201, 'Agent 05',    'ACA', 110, 0.080),
(202, 'Agent 06',    'ACA', 70, 0.095),
(203, 'Agent 07',    'ACA', 125, 0.060),
(204, 'Agent 08',    'ACA', 90, 0.120),
(301, 'Agent 09',    'Medicaid', 100, 0.075),
(302, 'Agent 10',    'Medicaid', 85, 0.080),
(303, 'Agent 01',    'Medicaid', 115, 0.070),
(304, 'Agent 01',    'Medicaid', 60, 0.100)

select * 
from dbo.Agents


Create Table dbo.Sales(
Sales_Id Int identity(1,1) primary Key,
Call_id Int,
Agent_id Int,
Sales_date Date
)

--Template for daily Calls

Create Table dbo.Daily_calls(
Call_id Int identity(1,1) primary Key,
Agent_id Int,
Team Varchar(50),
Call_date Date,
Lead_source Varchar(20),
Talk_second Int,
SRC_rand Int
)


Select Top (200) ROW_NUMBER() Over (Order by (select null)) - 1 As K
Into #n From sys.all_objects;

SELECT DATEADD(day,-K,cast(Getdate() As date )) As Call_Date 
Into #work_days
From #n
Where K < 90
And DATEDIFF(Day,'19000101',Dateadd(Day,-K,Cast(GETDATE() As date))) % 7 < 5;-- (5 days out the 7 days)

/**
k        result
0         2026-10-24
1         2026-10-23
2         2026- 10-22
**/
/**
oct 24 sat 5  kept no 
oct 23 fri 4  kept yes 

**/


select *
From #n

SELECT a.agent_id,
       a.Team,
       b.call_date,
       a.Base_calls + ABS(CHECKSUM(NEWID())) % 41-20 as N_Calls
Into #Agent_day
From dbo.Agents a
Cross Join #work_days b

Select * 
from #Agent_day

Insert into Daily_calls
(Agent_id,Team,Call_date,Talk_second,SRC_rand)
Select
     ad.Agent_id,
     ad.Team,
     ad.call_date,
     60+ABS(checksum(NEWID())) % 900,
     ABS(Checksum(NEWID())) % 100
From #Agent_day ad
Join #n k
on k.K < ad.N_Calls;

UPDATE Daily_calls
SET Lead_source = Case
When SRC_rand < 35 THEN 'TV'
When SRC_rand < 70 THEN 'DIGITAL'
When SRC_rand < 85 THEN 'DIRECT MAIL'
ELSE 'REFERRALS'
END;


--Creating a Temp Table for Sales 

Create Table dbo.Sales(
Sales_Id Int identity(1,1) primary Key,
Call_id Int,
Agent_id Int,
Sales_date Date
);

Insert into dbo.Sales(Call_id,Agent_id,Sales_date)
Select c.call_id,c.Agent_id,c.call_date
From Daily_calls c
Join Agents a
On a.Agent_id = c.Agent_id
where ABS(checksum(NEWID())) % 1000 < 
a.close_rate * 1000 *
Case
c.Lead_source 
When 'REFERRALS' THEN 1.6
When 'TV' THEN 1.0
When 'DIGITAL' THEN 0.8
ELSE 0.7
END;

SELECT *
FROM Sales

SELECT *
FROM Daily_calls

SELECT *
FROM Agents


--x = calls that  agent made that day 
--y = sales that agent closed that day 

Select 
       c.agent_id,
       c.team,
       c.call_date,
       CAST(count(*) as Float) as Calls,
       CAST(COUNT(s.Sales_Id) as Float) as Sales
into #agent_daily
from Daily_calls c
left join Sales s
on s.Call_id  = c.Call_id
group by    c.agent_id,c.team, c.call_date;


select COUNT(distinct Agent_id) as recordcount
from #agent_daily

----calculate the regression
with trendsums As ( 
   select 
    COUNT(*) as n,
    SUM(calls) as sx,
    SUM(sales) as sy,
    SUM(calls * sales) as sxy,
    SUM(calls * Calls) as sxx,
    SUM(sales * sales) as syy
From #agent_daily
) 
Select 
n, 
((n*sxy - sx*sy) / NULLIF(n*sxx - sx*sx, 0)as slope ,
((sy - ((n*sxy - sx*sy) / Nullif (n*sxx - sx*sx, 0)) * sx) / n as intercept,
POWER((n*sxy - sx*sy) 
     /  Nullif (sqrt((n*sxx - sx*sx)* (n*syy-sy*sy)), 0), 2) R_squared 
into #Modelbuild
from trendsums



select 
n,
CAST(slope as decimal(10,2)) as slope,  --- each extra call as about 4% sales 
cast(intercept as decimal(10,2))  as Intercept,  --- baseline daily sales regardless of the vol
cast(r_squared as decimal(10,2)) as r_squared   ----  call vol explains about 9% of the viration in sales 
from #Modelbuild


