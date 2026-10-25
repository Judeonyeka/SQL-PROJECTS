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
/* Customers	        Customer Management
   Accounts	            Account Management
   Transactions	        Banking Transactions
   Cards	            Card Management
   Card_Transactions	Card Spending
   Loans	            Loan Management
   Loan_Payments	    Loan Repayment
   Branches	            Branch Management
   Employees	        Employee Management
   Support_Tickets  	Customer Support
*/

WITH Account_Management AS(
SELECT 
      c.[Name],
      a.Account_id,
      a.Customer_id,
      c.Gender,
      c.date_of_birth,
      b.Branch_name,
      b.branch_id,
      a.Account_type,
      a.Open_date,    
      c.phone,
      c.email,
      c.occupation,
      a.Balance,
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
      c.customer_id,
      c.[name],
      c.gender,
      c.date_of_birth,
      c.city,
      c.[state],
      c.phone,
      c.email,
      c.occupation,
      c.join_date,
      c.credit_score,
      e.[role]
FROM Accounts a
inner join customers c
     ON a.customer_id = c.customer_id
inner Join Employees e
     ON a.branch_id = e.branch_id
),
--SELECT *
--FROM Customer_Management

Card_Management AS (
SELECT 
      cd.card_id,
      cd.customer_id,
      cd.account_id,
      cd.card_type,
      cd.issue_date,
      cd.[expiry_date],
      cd.credit_limit,
      t.card_txn_id,
      t.txn_date,
      t.merchant_category,
      t.amount,
      t.is_fraud,
      cd.[status] as Card_status
FROM Cards Cd
JOIN Card_Transactions T
     ON Cd.card_id = t.card_id
),
--SELECT *
--FROM Card_Management

Loan_Management AS (
SELECT 
      l.branch_id,
      l.loan_id,
      l.customer_id,
      p.payment_id,
      l.loan_type,
      l.loan_amount,
      l.interest_rate,
      l.term_months,
      l.[start_date],
      p.payment_date,
      p.amount_paid,
      p.principal_component,
      p.interest_component,
      p.late_payment_flag
FROM  Loans L
INNER JOIN Loan_Payments p
      ON L.loan_id = P.loan_id
),
--SELECT*
--FROM Loan_Management
cte_Support_Tickets AS (
SELECT
      s.ticket_id,
      s.customer_id,
      s.issue_type,
      s.date_opened,
      s.date_resolved,
      s.[status] as ticket_status,
      s.satisfaction_score,
case
when Satisfaction_score = 1 then '1 star'
when Satisfaction_score between 2 and 4 then '3 star'
when Satisfaction_score = 5 then '5 star'
end as 'star_rating_Flag'
FROM support_tickets s
),
--SELECT *
--FROM CTE_Support_Tickets
--order by star_rating_Flag asc

JUDE_BANK_MGT_SUMMARY AS (
select 
--Comming from the Account table
      a.[Name],
      a.Gender,
      a.Account_id,
      a.Customer_id,
      a.branch_id,
      a.Branch_name,
      a.Account_type,
      a.date_of_birth,
      a.Open_date,    
      a.phone,
      a.email,
      a.Balance,
      a.credit_score,
--Comming from the customer management table
      c.city,
      c.[state],
      c.occupation,
      c.join_date,
      c.[role],
--Comming from Cards
      cd.card_id,
      cd.card_type,
      cd.issue_date,
      cd.[expiry_date],
      cd.credit_limit,
      cd.card_txn_id,
      cd.txn_date,
      cd.merchant_category,
      cd.amount,
      cd.is_fraud,
      cd.card_status,
-- Comming from the loan managemt
      l.loan_id,
      l.payment_id,
      l.loan_type,
      l.loan_amount,
      l.interest_rate,
      l.term_months,
      l.[start_date],
      l.payment_date,
      l.amount_paid,
      l.principal_component,
      l.interest_component,
      l.late_payment_flag,
--comming from Support_Tickets
      s.ticket_id,
      s.issue_type,
      s.date_opened,
      s.date_resolved,
      s.ticket_status,
      s.satisfaction_score,
      s.star_rating_Flag
From  Account_Management a
right Join customer_management c
     On c.customer_id = a.customer_id
right Join Card_Management cd
     on cd.account_id = a.account_id
right Join Loan_Management l
     on l.customer_id = a.customer_id
right Join cte_Support_Tickets s
     On s.customer_id = a.customer_id
)
SELECT *
FROM JUDE_BANK_MGT_SUMMARY;













      -- why thisCTE/ know this 