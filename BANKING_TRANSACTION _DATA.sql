
--------------------------------------------------------------------------------------------------------
    --FINAL DESTINATION TABLE (TGT)
    --DROP TABLE IF EXISTS J_BANK_EXECUTIVE_SUMMARY
    CREATE TABLE J_BANK_EXECUTIVE_SUMMARY (
    [Name] VARCHAR(50),
    Gender VARCHAR(10),
    Account_id INT NOT NULL,
    Customer_id INT,
    branch_id INT,
    Branch_name VARCHAR(50),
    Account_type VARCHAR(20),
    date_of_birth DATE,
    Age INT,
    Age_Group VARCHAR(20),
    Age_classification Varchar(15),
    city VARCHAR(20),
    [state] VARCHAR(50),
    Occupation VARCHAR(50),
    Join_date DATE,
    Open_date DATE,
    Phone BIGINT,
    email VARCHAR(60),
    Balance DECIMAL(18,2),
    annual_income DECIMAL(18,2),
    [Savings_Rate%] DECIMAL(5,2),
    credit_score INT,
    [Status] VARCHAR(10),
    Income_Level VARCHAR(30),
    Total_Card_Transactions INT,
    Total_Card_Spent DECIMAL(18,2),
    Last_Transaction_Date DATE,
    Day_since_last_transaction INT,
    Total_Loans INT,
    Total_Loan_Amount DECIMAL(18,2),
    Total_Amount_Paid DECIMAL(18,2),
    Last_Payment_Date DATE,
    Total_Tickets INT,
    Average_Satisfaction_Score DECIMAL(5,2),
    PRIMARY KEY (Account_id)
);


 --STAGGING TABLE  -- (SOURCE TABLE)
 --DROP TABLE IF EXISTS STG_J_BANK_EXECUTIVE_SUMMARY
    CREATE TABLE STG_J_BANK_EXECUTIVE_SUMMARY(
    [Name] VARCHAR(50),
    Gender VARCHAR(10),
    Account_id INT NOT NULL,
    Customer_id INT,
    branch_id INT,
    Branch_name VARCHAR(50),
    Account_type VARCHAR(20),
    date_of_birth DATE,
    Age INT,
    Age_Group VARCHAR(20),
    Age_classification varchar(15),
    city VARCHAR(20),
    [state] VARCHAR(50),
    Occupation VARCHAR(50),
    Join_date DATE,
    Open_date DATE,
    Phone BIGINT,
    email VARCHAR(60),
    Balance DECIMAL(18,2),
    annual_income DECIMAL(18,2),
    [Savings_Rate%] DECIMAL(5,2),
    credit_score INT,
    [Status] VARCHAR(10),
    Income_Level VARCHAR(30),
    Total_Card_Transactions INT,
    Total_Card_Spent DECIMAL(18,2),
    Last_Transaction_Date DATE,
    Day_since_last_transaction INT,
    Total_Loans INT,
    Total_Loan_Amount DECIMAL(18,2),
    Total_Amount_Paid DECIMAL(18,2),
    Last_Payment_Date DATE,
    Total_Tickets INT,
    Average_Satisfaction_Score DECIMAL(5,2),
    PRIMARY KEY (Account_id)
);

 
ALTER TABLE STG_J_BANK_EXECUTIVE_SUMMARY             --Here also, I will add a new column to handle duplicates
ADD Load_date DATETIME;

ALTER TABLE J_BANK_EXECUTIVE_SUMMARY
ADD Load_date DATETIME;

--STORE PROCEDURE

CREATE OR ALTER PROCEDURE SP_LOAD_BANK_SUM_EXECUTIVE_DATA
AS
BEGIN
SET NOCOUNT ON;

--Next step is to clear all data that we have in the Stg_table and get them ready for the destination table by:

TRUNCATE TABLE STG_J_BANK_EXECUTIVE_SUMMARY;

WITH Account_Management AS (
SELECT 
      c.[Name],
      a.Account_id,
      a.Customer_id,
      c.Gender,
      c.date_of_birth,
      DATEDIFF(YEAR, c.date_of_birth, GETDATE()) --Calculate the difference between birth year and current year
      -
      CASE
      WHEN DATEADD(YEAR, DATEDIFF(YEAR,c.date_of_birth,GETDATE()),-- This actually take the person's date of birth and add the number of years they have lived to it.
      c.date_of_birth) > GETDATE() THEN 1 --Here,Has the person's birthday happened yet this year? if no then remove 1, and if yes leave it at that (0).
      ELSE 0 
      END AS Age,
      CASE
      WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 25 THEN '1-24'
      WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 25 AND 34 THEN '25-34'
      WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 35 AND 44 THEN '35-44'
      WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 45 AND 54 THEN '45-54'
      WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 55 AND 64 THEN '55-64'
      ELSE '65+'
      END AS Age_Group,
      CASE
      WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 1 AND 17 THEN 'Minor'
      WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 18 AND 70 THEN 'Adult'
      ELSE 'Senior'
      END AS Age_classification,
      b.Branch_name,
      b.branch_id,
      a.Account_type,
      a.Open_date,    
      c.phone,
      c.email,
      c.occupation,
      a.Balance,
      ROUND((a.Balance / NULLIF(c.annual_income,0)) * 100,2) AS [Savings_Rate%],
      c.credit_score,
      a.[Status]
FROM Accounts a
JOIN Branches b
     ON a.branch_id = b.branch_id
JOIN Customers c
     ON a.customer_id  = c.customer_id
),
--SELECT * 
--FROM Account_Management

Customer_Management AS(
SELECT 
      customer_id,
      [name],
      gender,
      date_of_birth,
      city,
      [state],
      phone,
      email,
      occupation,
      join_date,
      annual_income,
      CASE
      WHEN annual_income < 30000 THEN 'Low Income'
      WHEN annual_income BETWEEN 30000 AND 59999 THEN 'Middle Income'
      WHEN annual_income BETWEEN 60000 AND 99999 THEN 'High Income'
      ELSE 'Very High Income'
      END AS Income_Level,
      Credit_score
FROM  Customers
),
--SELECT *
--FROM Customer_Management
Card_Summary AS
(
SELECT
    cd.account_id,
    COUNT(t.card_txn_id) AS Total_Card_Transactions,
    SUM(COALESCE(t.amount,0)) AS Total_Card_Spent,
    MAX(t.txn_date) AS Last_Transaction_Date,
    DATEDIFF (DAY,Max(t.txn_date), GETDATE()) AS Day_since_last_transaction
FROM Cards cd
LEFT JOIN Card_Transactions t
    ON cd.card_id = t.card_id
GROUP BY cd.account_id
),
--SELECT *
--FROM Card_Summary

Loan_Summary AS
(
SELECT
      l.customer_id,
      COUNT(l.loan_id) AS Total_Loans,
      SUM(COALESCE(l.loan_amount,0)) AS Total_Loan_Amount,
      SUM(COALESCE(p.amount_paid,0)) AS Total_Amount_Paid,
      MAX (p.payment_date) AS Last_Payment_Date
FROM Loans l
LEFT JOIN Loan_Payments p
     ON l.loan_id = p.loan_id
GROUP BY l.customer_id
),
--SELECT*
--FROM loan_summary

Support_Summary AS
(
SELECT
      customer_id,
      COUNT(ticket_id) AS Total_Tickets,
      ROUND(AVG(satisfaction_score),2) AS Average_Satisfaction_Score
FROM Support_Tickets
GROUP BY customer_id
),
--SELECT *
--FROM Support_Tickets

JUDE_BANK_MGT_SUMMARY AS
(
SELECT

-- Account information
      a.Account_id,
      a.[Name],
      a.Gender,
      a.Customer_id,
      a.branch_id,
      a.Branch_name,
      a.Account_type,
      a.date_of_birth,
      a.age,
      a.Age_group,
      a.Age_classification,
      c.city,  --comming from customers_Mgt
      c.[state],--comming from customers_Mgt
      c.occupation,--comming from customers_Mgt
      c.join_date,--comming from customers_Mgt
      a.Open_date,
      a.phone,
      a.email,
      a.Balance,
      c.annual_income,--comming from customers_Mgt
      a.[Savings_Rate%],
      a.credit_score,
      a.[Status],

-- Customer information-Other Columns was not included in this section to help make the table mk sense 
      c.Income_Level,

-- Card summary
      cs.Total_Card_Transactions,
      cs.Total_Card_Spent,
      cs.Last_Transaction_Date,
      cs.Day_since_last_transaction,

-- Loan summary
      ls.Total_Loans,
      ls.Total_Loan_Amount,
      ls.Total_Amount_Paid,
      ls.Last_Payment_Date,

-- Support summary
      ss.Total_Tickets,
      ss.Average_Satisfaction_Score


FROM Account_Management a

LEFT JOIN Customer_Management c
     ON a.Customer_id = c.Customer_id

LEFT JOIN Card_Summary cs
    ON a.account_id = cs.account_id

LEFT JOIN Loan_Summary ls
     ON a.Customer_id = ls.Customer_id

LEFT JOIN Support_Summary ss
     ON a.Customer_id = ss.Customer_id
)

--SELECT *
--FROM JUDE_BANK_MGT_SUMMARY
--order by Account_type asc;

INSERT INTO STG_J_BANK_EXECUTIVE_SUMMARY
(
        [Name],
        Gender,
        Account_id,
        Customer_id,
        branch_id,
        Branch_name,
        Account_type,
        date_of_birth,
        Age,
        Age_Group,
        Age_classification,
        city,
        [state],
        Occupation,
        Join_date,
        Open_date,
        Phone,
        email,
        Balance,
        annual_income,
        [Savings_Rate%],
        credit_score,
        [Status],
        Income_Level,
        Total_Card_Transactions,
        Total_Card_Spent,
        Last_Transaction_Date,
        Day_since_last_transaction,
        Total_Loans,
        Total_Loan_Amount,
        Total_Amount_Paid,
        Last_Payment_Date,
        Total_Tickets,
        Average_Satisfaction_Score,
        Load_date
    )

    SELECT
        [Name],
        Gender,
        Account_id,
        Customer_id,
        branch_id,
        Branch_name,
        Account_type,
        date_of_birth,
        Age,
        Age_Group,
        Age_classification,
        city,
        [state],
        Occupation,
        Join_date,
        Open_date,
        Phone,
        email,
        Balance,
        annual_income,
        [Savings_Rate%],
        credit_score,
        [Status],
        Income_Level,
        Total_Card_Transactions,
        Total_Card_Spent,
        Last_Transaction_Date,
        Day_since_last_transaction,
        Total_Loans,
        Total_Loan_Amount,
        Total_Amount_Paid,
        Last_Payment_Date,
        Total_Tickets,
        Average_Satisfaction_Score,
        Getdate()
FROM JUDE_BANK_MGT_SUMMARY;

-- Here we re merging the S table to the t table (destination table).

MERGE J_BANK_EXECUTIVE_SUMMARY AS T
USING STG_J_BANK_EXECUTIVE_SUMMARY AS S
ON T.account_id = S.account_id
WHEN MATCHED THEN
UPDATE SET
            T.[Name] = S.[Name],
            T.Gender = S.Gender,
            T.Customer_id = S.Customer_id,
            T.branch_id = S.branch_id,
            T.Branch_name = S.Branch_name,
            T.Account_type = S.Account_type,
            T.date_of_birth = S.date_of_birth,
            T.Age = S.Age,
            T.Age_Group = S.Age_Group,
            T.Age_classification = S.Age_classification,
            T.city = S.city,
            T.[state] = S.[state],
            T.Occupation = S.Occupation,
            T.Join_date = S.Join_date,
            T.Open_date = S.Open_date,
            T.Phone = S.Phone,
            T.email = S.email,
            T.Balance = S.Balance,
            T.annual_income = S.annual_income,
            T.[Savings_Rate%] = S.[Savings_Rate%],
            T.credit_score = S.credit_score,
            T.[Status] = S.[Status],
            T.Income_Level = S.Income_Level,
            T.Total_Card_Transactions =S.Total_Card_Transactions,
            T.Total_Card_Spent =S.Total_Card_Spent,
            T.Last_Transaction_Date =S.Last_Transaction_Date,
            T.Day_since_last_transaction =S.Day_since_last_transaction,
            T.Total_Loans =S.Total_Loans,
            T.Total_Loan_Amount =S.Total_Loan_Amount,
            T.Total_Amount_Paid =S.Total_Amount_Paid,
            T.Last_Payment_Date = S.Last_Payment_Date,
            T.Total_Tickets = S.Total_Tickets,
            T.Average_Satisfaction_Score = S.Average_Satisfaction_Score,
            T.Load_date = Getdate()
WHEN NOT MATCHED BY TARGET THEN
INSERT (
            [Name],
            Gender,
            Account_id,
            Customer_id,
            branch_id,
            Branch_name,
            Account_type,
            date_of_birth,
            Age,
            Age_Group,
            Age_classification,
            city,
            [state],
            Occupation,
            Join_date,
            Open_date,
            Phone,
            email,
            Balance,
            annual_income,
            [Savings_Rate%],
            credit_score,
            [Status],
            Income_Level,
            Total_Card_Transactions,
            Total_Card_Spent,
            Last_Transaction_Date,
            Day_since_last_transaction,
            Total_Loans,
            Total_Loan_Amount,
            Total_Amount_Paid,
            Last_Payment_Date,
            Total_Tickets,
            Average_Satisfaction_Score,
            Load_date
)
VALUES 
(
            S.[Name],
            S.Gender,
            S.Account_id,
            S.Customer_id,
            S.branch_id,
            S.Branch_name,
            S.Account_type,
            S.date_of_birth,
            S.Age,
            S.Age_Group,
            S.Age_classification,
            S.city,
            S.[state],
            S.Occupation,
            S.Join_date,
            S.Open_date,
            S.Phone,
            S.email,
            S.Balance,
            S.annual_income,
            S.[Savings_Rate%],
            S.credit_score,
            S.[Status],
            S.Income_Level,
            S.Total_Card_Transactions,
            S.Total_Card_Spent,
            S.Last_Transaction_Date,
            S.Day_since_last_transaction,
            S.Total_Loans,
            S.Total_Loan_Amount,
            S.Total_Amount_Paid,
            S.Last_Payment_Date,
            S.Total_Tickets,
            S.Average_Satisfaction_Score,
            Getdate()
        );         
END;
                                                                  


