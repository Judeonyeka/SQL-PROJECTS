CREATE DATABASE Bank_Tran_datasets;

Use Bank_Tran_datasets

--Bulk Insertion of data.

CREATE TABLE Accounts (
account_id	 int,
customer_id	 int,
branch_id	 int,
account_type Varchar(50),
balance	     Float,
open_date    Date,
[status]     Varchar(15)
)

BULK INSERT  Accounts
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\accounts.csv'
WITH
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)

SELECT *
FROM Accounts
------------------------------------------------------------------------------------------------------------
CREATE TABLE Branches (
branch_id    int,
branch_name  Varchar(20),	
city	     Varchar(20),
[state]	     Varchar(20),
opened_date	 Date,
ifsc_code    Varchar(20)
)

BULK INSERT Branches
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\branches.csv'
WITH
(
FORMAT          = 'csv',
FIRSTROW        = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR   = '0X0a'
)

SELECT *
FROM Branches
------------------------------------------------------------------------------------------------------------
Drop table if exists card_transactions
CREATE TABLE card_transactions (
card_txn_id        int,
card_id	           int,
txn_date           Date, 
merchant_category  varchar(30),
amount	           Money,
is_fraud           int
)

BULK INSERT card_transactions
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\card_transactions.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)

SELECT *
FROM card_transactions;
--------------------------------------------------------------------------------
CREATE TABLE cards(
card_id	           int,
customer_id	       int,
account_id	       int,
card_type	       Varchar(30),
issue_date	       Date,
[expiry_date]	   Date,
credit_limit	   money,
[status]           Varchar(30)
)

BULK INSERT cards
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\cards.csv'
WITH
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)

SELECT *
FROM cards
------------------------------------------------------------------------------------------------
Drop Table if exists Customers
CREATE TABLE Customers(
customer_id	        Int,
[name]	            Varchar(20),
gender	            Varchar(20),
date_of_birth	    Date,
city	            Varchar(20),
[state]	            Varchar(20),
phone	            Bigint,
email	            Varchar (30),
occupation	        Varchar(30),
annual_income	    Int,
join_date	        Date,
credit_score        Int
)

BULK INSERT Customers
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\customers.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0X0a'
)

SELECT *
FROM Customers;
------------------------------------------------------------------------------------------------

CREATE TABLE employees(
employee_id	     int,
[name]	         Varchar(20),
branch_id	     int,
[role]	         Varchar(30),
hire_date	     Varchar(20),
salary           Money
)

BULK INSERT employees
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\employees.csv'
WITH
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0X0a'
)

SELECT *
FROM employees
-----------------------------------------------------------------------------------------------

CREATE TABLE loan_payments(
payment_id	           Int,
loan_id	               Int,
payment_date	       Date,
amount_paid	           Money,
principal_component	   Float,
interest_component	   Float,
late_payment_flag      int
)

BULK INSERT loan_payments
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\loan_payments.csv'
WITH
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)

SELECT *
FROM loan_payments
-------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS loans
CREATE TABLE loans(
loan_id	       int,
customer_id	   int,
branch_id	   int,
loan_type	   Varchar(20),
loan_amount	   Money,
interest_rate  Float,	
term_months	   int,
[start_date]   date,	
[status]       Varchar(20)
)

BULK INSERT loans
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\loans.csv'
WITH 
(
FORMAT = 'csv',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)

SELECT *
FROM loans
-----------------------------------------------------------------------------------------------------
CREATE TABLE support_tickets(
ticket_id	        int,
customer_id	        int,
issue_type	        Varchar(20),
date_opened	        Date,
date_resolved	    Date,
[status]	        Varchar(10),
satisfaction_score  int
)

BULK INSERT support_tickets
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\support_tickets.csv'
WITH 
(
FORMAT    ='csv',
FIRSTROW   = 2,
FIELDTERMINATOR   = ',',
ROWTERMINATOR     = '0X0a'
)

SELECT *
FROM support_tickets
---------------------------------------------------------------------------------------------------------

CREATE TABLE transactions(
transaction_id	   int,
account_id	       int,
txn_date	       date,
txn_type	       Varchar(20),
amount	           Money,
channel	           varchar(20),
merchant_category  varchar(20)
)

BULK INSERT transactions
FROM 'C:\Users\jonye\OneDrive\Desktop\SQL Classes\CLASSES MATERIALS\Banking_transactions_datasets\transactions.csv'
WITH 
(
FORMAT   = 'csv',
FIRSTROW =  2,
FIELDTERMINATOR = ',',
ROWTERMINATOR   = '0x0a'
)

SELECT * 
FROM transactions

---------------------------------------------------------------------------------------------------
SELECT Top 1 *
FROM Accounts

SELECT Top 1 *
FROM Branches

SELECT Top 1 *
FROM card_transactions          --To get the relationships 

SELECT Top 1 *
FROM cards

SELECT Top 1 *
FROM Customers;

SELECT Top 1 *
FROM employees

SELECT Top 1 *
FROM loan_payments

SELECT Top 1 *
FROM loans

SELECT Top 1 *
FROM support_tickets

SELECT Top 1 *
FROM transactions

---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- we are going to work on the below with CTE to solve and build the queries of what we wish to achieve.
/*  Customer Management
    Account Management
   	Card_summary 
    Loan_summary
    Support_Tickets 
*/
--CTE

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
SELECT *
FROM JUDE_BANK_MGT_SUMMARY
ORDER BY Account_id;


-- FINAL TABLE IS ARRANGED AS NEEDED