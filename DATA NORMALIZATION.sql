--DATA NORMALIZATION:
/* This is a process of organizing Datas and cleaning Datas, eg, Handling duplicates. Without normalizing datas it gives you alot of erros in datas or working on updates.
It helps with data integrity,standardization and organization of data.
It also relies on making data more simple,safer and easy to read.

FIRST NORMAL FORM:
Rules:
i) Every column holds single atomic or unique values,meaning no repeating group, no coma seprated list in a Cell.
 - IN OTHER WORD, THIS FORM STATES THAT EVERY CELL MUST CONTAIN ONE VALUE.

SECOND NORMAL FORM:
Rule:
i)It must already be in the first normal form and every non key colunm must depend on the whole primary key and
  not just part of it. 
This only matters when you have a composite key.

THIRD NORMAL FORM: must already be in the second normal form and non key column depending on another non key column

*/

CREATE TABLE Enrollment_Flat (
    EnrollmentID    INT,
    EnrollDate      DATE,
    AgentID         INT,
    AgentName       VARCHAR(100),
    AgentSite       VARCHAR(50),
    AgentManager    VARCHAR(100),
    MemberID        INT,
    MemberName      VARCHAR(100),
    MemberState     VARCHAR(2),
    PlanCode        VARCHAR(10),
    PlanName        VARCHAR(100),
    PlanPremium     DECIMAL(10,2),
    PlanType        VARCHAR(20),      -- e.g. 'HMO','PPO'
    EnrollmentStatus VARCHAR(20)
);

INSERT INTO Enrollment_Flat 
VALUES
(1, '2026-01-05', 101, 'Kevin Maddy', 'Site A', 'Yamara Flores Torres', 5001, 'Jane Doe', 'TX', 'PL01', 'Gold Advantage', 210.00, 'HMO', 'Active'),
(2, '2026-01-06', 101, 'Kevin Maddy', 'Site A', 'Yamara Flores Torres', 5002, 'John Roe', 'TX', 'PL01', 'Gold Advantage', 210.00, 'HMO', 'Active'),
(3, '2026-01-06', 102, 'Sara Lin',    'Site B', 'Felix Garcia',         5003, 'Amy Kim', 'CA', 'PL02', 'Silver Basic', 150.00, 'PPO', 'Pending');

SELECT *
FROM Enrollment_Flat;

CREATE TABLE Customer_raw(
Customer_id int,
Customer_name varchar(100),
customer_phone_number varchar(100)
);

INSERT INTO Customer_raw 
VALUES
(5001, 'Jane Doe',  '555-1234, 555-5678'),
(5002, 'John Roe',  '555-9999'),
(5003, 'Amy Kim',   '555-2222, 555-3333, 555-4444');

SELECT *
FROM Customer_raw;

CREATE TABLE Customer_1NF(
Customer_id int PRIMARY KEY,
Customer_Name varchar(100)
);

CREATE TABLE Customer_Phone_number_1NF(
Customer_id int REFERENCES Customer_1NF(Customer_id),
Customer_Phone_number varchar(100),
PRIMARY KEY(Customer_id,Customer_Phone_number)               -- UNIQUE KEY(More than one primary key)
);

INSERT INTO Customer_1NF
VALUES
(5001, 'Jane Doe'),
(5002, 'John Roe'),
(5003, 'Amy Kim');

INSERT INTO Customer_Phone_number_1NF 
VALUES
(5001, '555-1234'),
(5001, '555-5678'),
(5002, '555-9999'),
(5003, '555-2222'),
(5003, '555-3333'),
(5003, '555-4444');

SELECT *
FROM Customer_1NF

SELECT *
FROM Customer_Phone_number_1NF

SELECT *
FROM Customer_raw

--FORM 2

--Exercise; Write a case table statement for Agents,Members,plans and normalize Enrollment Table
-- Here, we are going to create a Child/parent table for Agents,Members,plans refrencing them with an enrolment table

DROP TABLE Agents_Norm
CREATE TABLE Agents_Norm (
    AgentID      INT, --PRIMARY KEY,
    AgentName    VARCHAR(100) NOT NULL,
    AgentSite    VARCHAR(50),
    AgentManager VARCHAR(100)
)
INSERT INTO Agents_Norm                                 --SubQuery
(
      AgentID,
      AgentName,
      AgentSite,
      AgentManager
 )
SELECT 
       AgentID,
       AgentName,
       AgentSite,
       AgentManager
From Enrollment_Flat


DROP TABLE Members_Norm
CREATE TABLE Members_Norm (
    MemberID     INT, --PRIMARY KEY,
    MemberName   VARCHAR(100) NOT NULL,
    MemberState  VARCHAR(2)
)
INSERT INTO Members_Norm
(MemberID,MemberName,MemberState)
SELECT
     MemberID,
     MemberName,
     MemberState
FROM Enrollment_Flat;


     


DROP TABLE Plans_Norm
CREATE TABLE Plans_Norm (
    PlanCode     VARCHAR(10), --PRIMARY KEY,
    PlanName     VARCHAR(100) NOT NULL,
    PlanPremium  DECIMAL(10,2),
    PlanType     VARCHAR(20)
);

INSERT INTO Plans_Norm
(PlanCode,PlanName,PlanPremium,PlanType)
SELECT
      PlanCode,
      PlanName,
      PlanPremium,
      PlanType
FROM Enrollment_Flat
     

DROP TABLE Enrollments_Norm
CREATE TABLE Enrollments_Norm (
    EnrollmentID     INT, --PRIMARY KEY,
    EnrollDate       DATE NOT NULL,
    AgentID          INT, --REFERENCES Agents_Norm(AgentID),
    MemberID         INT, --REFERENCES Members_Norm(MemberID),
    PlanCode         VARCHAR(10), --REFERENCES Plans_Norm(PlanCode),
    EnrollmentStatus VARCHAR(20)
);

INSERT INTO Enrollments_Norm
(EnrollmentID,EnrollDate,AgentID,MemberID,PlanCode,EnrollmentStatus)
SELECT
     e.EnrollmentID,
     e.EnrollDate,
     a.AgentID,
     m.MemberID,
     p.PlanCode,
     e.EnrollmentStatus
FROM Enrollment_Flat e
JOIN Agents_Norm  a
ON e.AgentID = a.AgentID
JOIN Members_Norm m
ON e.MemberID = m.MemberID
JOIN Plans_Norm   p 
ON e.PlanCode = p.PlanCode;


-- Here we are rebuilding the Fact report View
SELECT
    e.EnrollmentID,
    e.EnrollDate,
    a.AgentName,
    a.AgentSite,
    a.AgentManager,
    m.MemberName,
    m.MemberState,
    p.PlanName,
    p.PlanPremium,
    p.PlanType,
    e.EnrollmentStatus
FROM Enrollments_Norm e
JOIN Agents_Norm  a
ON e.AgentID = a.AgentID
JOIN Members_Norm m
ON e.MemberID = m.MemberID
JOIN Plans_Norm   p 
ON e.PlanCode = p.PlanCode;


-- 3_NF

CREATE TABLE Encounters_NF(
    EncounterID   INT,
    EncounterDate DATE,
    PatientID     INT,
    PatientName   VARCHAR(100),
    ProviderID    INT,
    ProviderName  VARCHAR(100),
    ProviderNPI   VARCHAR(20),
    FacilityID    INT,
    FacilityName  VARCHAR(100),
    DiagnosisCode VARCHAR(10),
    DiagnosisDesc VARCHAR(200)
);

INSERT INTO Encounters_NF VALUES
(90001, '2026-02-10', 30001, 'Maria Gonzalez', 401, 'Dr. Emily Foster',  '1234567890', 701, 'Riverside Medical Center', 'E11.9',  'Type 2 diabetes mellitus without complications'),
(90002, '2026-02-11', 30002, 'David Chen',     402, 'Dr. Rajesh Patel',  '2345678901', 702, 'Northgate Clinic',        'J45.909','Unspecified asthma, uncomplicated'),
(90003, '2026-02-12', 30003, 'Angela Brooks',  401, 'Dr. Emily Foster',  '1234567890', 701, 'Riverside Medical Center', 'M54.5',  'Low back pain'),
(90004, '2026-02-14', 30001, 'Maria Gonzalez', 403, 'Dr. Lisa Okafor',   '3456789012', 702, 'Northgate Clinic',        'I10',    'Essential (primary) hypertension'),
(90005, '2026-02-15', 30004, 'Tom Reyes',      401, 'Dr. Emily Foster',  '1234567890', 701, 'Riverside Medical Center', 'I10',    'Essential (primary) hypertension'),
(90006, '2026-02-16', 30002, 'David Chen',     402, 'Dr. Rajesh Patel',  '2345678901', 702, 'Northgate Clinic',        'E11.9',  'Type 2 diabetes mellitus without complications'),
-- deliberate data quality issue: same ProviderID, name entered inconsistently
(90007, '2026-02-17', 30005, 'Nina Patel',     401, 'Dr. E. Foster',     '1234567890', 701, 'Riverside Medical Center', 'M54.5',  'Low back pain'),
(90008, '2026-02-18', 30003, 'Angela Brooks',  403, 'Dr. Lisa Okafor',   '3456789012', 702, 'Northgate Clinic',        'J45.909','Unspecified asthma, uncomplicated'),
(90009, '2026-02-19', 30006, 'Carlos Ibarra',  402, 'Dr. Rajesh Patel',  '2345678901', 702, 'Northgate Clinic',        'E11.9',  'Type 2 diabetes mellitus without complications'),
(90010, '2026-02-20', 30004, 'Tom Reyes',      401, 'Dr. Emily Foster',  '1234567890', 701, 'Riverside Medical Center', 'E11.9',  'Type 2 diabetes mellitus without complications')


SELECT *
FROM Encounters_NF

--DATA PROFILING: This is to understand how your/Duplicates AND inconsistence of Dr Emily's name.

SELECT 
     ProviderID,
     ProviderName,
     COUNT(DISTINCT ProviderName) AS VARIANCE        --To handle Duplicates
FROM Encounters_NF
GROUP BY ProviderID,
         ProviderName
--HAVING COUNT(DISTINCT ProviderName) >1

SELECT *
FROM Encounters_NF
WHERE ProviderID = 401

--HOW TO FIX THIS VARIANCE 
--You have to start by ranking by most frequent name.

SELECT 
      ProviderID,
      ProviderName,
      Row_number()over(partition by providerID Order by COUNT(*) DESC) as RN
FROM Encounters_NF
GROUP BY ProviderID,
         ProviderName

--BUILDING A CROSS WORK -- Building a new table to insert it into 

CREATE TABLE Provider_Name_Crosswalk (
    ProviderID       INT,
    RawName          VARCHAR(100),
    CanonicalName    VARCHAR(100),
    PRIMARY KEY (ProviderID, RawName)
);

INSERT INTO Provider_Name_Crosswalk 
VALUES
(401, 'Dr. Emily Foster', 'Dr. Emily Foster'),
(401, 'Dr. E. Foster',    'Dr. Emily Foster'),  -- mapped to canonical
(402, 'Dr. Rajesh Patel', 'Dr. Rajesh Patel'),
(403, 'Dr. Lisa Okafor',  'Dr. Lisa Okafor');

SELECT *
FROM Provider_Name_Crosswalk 



CREATE OR ALTER VIEW CROSSWALKTABLE 
AS 
--CREATING A CROSS WALK FROM A CTE
WITH NameFrequence AS(
--step 1 is to count how oftenthe spelling of the name appears by providerID
SELECT 
     ProviderID,
     ProviderName,
     COUNT(*) AS Frequent       
FROM Encounters_NF
GROUP BY ProviderID,
         ProviderName
),
Rank_Names as (
--Step 2, Rank spelling with each provider ID
SELECT 
      ProviderID,
      ProviderName,
      Frequent,
      Row_number()over(partition by providerID Order by Frequent DESC) as RN
FROM NameFrequence
),
Canonical_pick AS(
-- STEP 3. The RN = 1 row per providerID becomes the canonical name
SELECT 
     ProviderID,
     ProviderName As Canonical_Name
     FROM RANK_Names
     WHERE RN =1
),
Crosswalk_mappingTable AS

(
--BUILDING A CROSSWALK EVERY RAW VARIANCE MAPPED TO ITS CANONICAL PICK
SELECT 
     nf.ProviderID,
     nf.ProviderName AS Raw_name,
     cp.Canonical_name
FROM NameFrequence nf
JOIN Canonical_pick cp
ON nf.ProviderID = cp.ProviderID
)
--crosswalking our map table to work with the original raw table
SELECT DISTINCT
    e.EncounterID,   
    e.EncounterDate, 
    e.PatientID,     
    e.PatientName,   
    e.ProviderID,    
    e.ProviderName,  
    e.ProviderNPI,   
    e.FacilityID,    
    e.FacilityName,  
    e.DiagnosisCode, 
    e.DiagnosisDesc
FROM Encounters_NF e
JOIN Canonical_pick cp
ON e.ProviderID = cp.ProviderID;

--VIEW TABLE
SELECT *
FROM CROSSWALKTABLE

CREATE TABLE PROVIDER AS
















































--PRACTICE ON DATA NORMALIZATION:

--Available Datas:
/*
gift hub
name 
document 
date of process 
and all the project you have done /*
