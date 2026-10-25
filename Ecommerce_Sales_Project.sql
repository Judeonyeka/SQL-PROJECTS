 CREATE DATABASE Ecommerce_Sales_Dataset;

 USE Ecommerce_Sales_Dataset;

 ----------------------------------------------------------------------------------------------------------------------
 --BULK INSERTION:

CREATE TABLE Customer_Master(
customer_id VARCHAR(100),
customer_name VARCHAR(100),	
customer_age INT,
gender VARCHAR(100),	
customer_segment VARCHAR(50),
customer_city VARCHAR(50),
customer_state VARCHAR(50),	
customer_country VARCHAR(50),	
region VARCHAR(50),
customer_postal_code INT,	
customer_acquisition_cost DECIMAL(5,2),
)

BULK INSERT Customer_Master
FROM 'C:\Users\jonye\OneDrive\Desktop\Ecommerce Sales Analytics Dataset\Customer_Master.CSV'
WITH
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
CREATE TABLE dataset_statistics(
Total_Transactions INT,
Total_Columns INT,
Total_Customers	INT,
Total_Products_Used	INT,
Date_Range VARCHAR(25),
Total_Revenue DECIMAL(15,5),
Total_Profit DECIMAL(15,5),	
Average_Order_Value	DECIMAL(15,5),
Average_Rating DECIMAL(15,5),
Return_Rate	DECIMAL(15,5),
Cancellation_Rate DECIMAL(15,5)
)

BULK INSERT dataset_statistics
FROM 'C:\Users\jonye\OneDrive\Desktop\Ecommerce Sales Analytics Dataset\dataset_statistics.CSV'
WITH
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0X0a'
)


CREATE TABLE ecommerce_sales_customer_analytics_150k(
order_id VARCHAR(20),
order_date DATE,
order_time TIME,
order_status VARCHAR(20),	
sales_channel VARCHAR(20),
customer_id VARCHAR(20),	
customer_name VARCHAR(50),	
customer_age INT,	
gender VARCHAR(20),
customer_segment VARCHAR(20),	
customer_type VARCHAR(20),	
customer_city VARCHAR(30),	
customer_state VARCHAR(20),	
customer_country VARCHAR(20),	
region VARCHAR(20),	
customer_postal_code INT,
payment_method VARCHAR(20),	
payment_status	VARCHAR(20),
currency VARCHAR(4),	
shipping_method	VARCHAR(20),
warehouse VARCHAR(20),
delivery_days FLOAT,	
estimated_delivery_days	INT,
delivery_status	VARCHAR(20),
return_status VARCHAR(20),	
return_reason VARCHAR(50),	
customer_rating	DECIMAL(12,2),
review_sentiment VARCHAR(20),
customer_review	VARCHAR(100),
marketing_channel VARCHAR(20),
campaign_name VARCHAR(20),
coupon_code	VARCHAR(20),
loyalty_points_earned INT,	
loyalty_points_redeemed	INT,
quantity	INT,
gross_sales	DECIMAL(15,5),
discount_amount	DECIMAL(15,5),
tax_amount	DECIMAL(15,5),
shipping_cost	DECIMAL(15,5),
net_sales DECIMAL(15,5),
product_cost DECIMAL(15,5),
profit	DECIMAL(15,5),
profit_margin_percentage DECIMAL(15,5),	
customer_lifetime_value	DECIMAL(15,5),
is_repeat_customer	VARCHAR(6),
customer_order_count INT
);

Bulk Insert ecommerce_sales_customer_analytics_150k
FROM 'C:\Users\jonye\OneDrive\Desktop\Ecommerce Sales Analytics Dataset\ecommerce_sales_customer_analytics_150k.csv'
WITH 
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0X0a'
)



CREATE TABLE order_items(
order_id VARCHAR(30),
product_id VARCHAR(30),	
quantity INT,
unit_price DECIMAL(10,3),	
discount_percentage	FLOAT,
discount_amount	FLOAT,
gross_sales	DECIMAL(18,9),
tax_amount DECIMAL(18,9),	
shipping_cost FLOAT,
net_sales DECIMAL(18,9),	
product_cost DECIMAL(18,9),	
profit DECIMAL(18,9)
)

BULK INSERT order_items
FROM 'C:\Users\jonye\OneDrive\Desktop\Ecommerce Sales Analytics Dataset\order_items.CSV'
WITH
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0X0a'
)


CREATE TABLE product_catalog(
product_id VARCHAR(50),
product_name VARCHAR(100),	
product_category VARCHAR(50),
product_subcategory	VARCHAR(50),
brand VARCHAR(50),	
supplier VARCHAR(50),
unit_price FLOAT,
product_cost DECIMAL(10,5),
product_rating FLOAT
)

BULK INSERT product_catalog
FROM 'C:\Users\jonye\OneDrive\Desktop\Ecommerce Sales Analytics Dataset\product_catalog.CSV'
WITH
(
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
-----------------------------------------------------------------------------------------------------------------------

--GETTING THE RELATIONSHIPS 

SELECT  * --CUSTOMERS INFO  ci
FROM Customer_Master;

SELECT  * --SUMMATION CATALOGUE
FROM dataset_statistics;

SELECT *--CUSTOMERS ANALYTICAL TABLE  ca
FROM ecommerce_sales_customer_analytics_150k;

SELECT *--SALES TABLE FROM ORDERS
FROM order_items;

SELECT TOP 1 *--PRODUCT INFO
FROM product_catalog;


select distinct customer_rating
from ecommerce_sales_customer_analytics_150k  
---------------------------------------------------------------------------------------------------------------------

 

CREATE or ALTER PROCEDURE SP_Ecommerce_summary as
BEGIN

SET NOCOUNT ON;

WITH Customer_Ranked AS
(
    -- Keep one customer record per Customer_id
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY Customer_id ORDER BY Customer_Name,Customer_Age,Gender,Customer_State,Customer_Country,Customer_Postal_Code) AS RN
    FROM Customer_Master 
),
--SELECT *
--FROM Customer_Ranked

CUSTOMERS_INFORMATION AS (
SELECT
        Customer_id,
        Customer_Name,
        Customer_Age AS Age,
        CASE
            WHEN Customer_Age < 18 THEN 'MINOR'
            WHEN Customer_Age BETWEEN 18 AND 29 THEN 'YOUNG'
            WHEN Customer_Age BETWEEN 30 AND 49 THEN 'ADULT'
            WHEN Customer_Age BETWEEN 50 AND 69 THEN 'SENIOR'
            WHEN Customer_Age >= 70 THEN 'OLD'
            ELSE 'OLDER'
            END AS Age_Category,
        Gender,
        Customer_State AS [State],
        Customer_Country AS Country,
        Customer_Postal_Code AS Code,
        Customer_Acquisition_Cost AS Acquisition_Cost
FROM Customer_Ranked
     WHERE RN = 1
),
--SELECT *
--FROM CUSTOMERS_INFORMATION

Order_Ranked AS (     -- Keep one analytics record per Order_id
  SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY Order_id ORDER BY Order_Date DESC, Order_Time DESC, Customer_id, Order_Status, Sales_Channel) AS RN
  FROM ecommerce_sales_customer_analytics_150k 
    WHERE Order_id IS NOT NULL
),

ORDER_INFORMATION AS
(
    SELECT
        Customer_id,
        Customer_Name AS Analytics_Customer_Name,
        Customer_Type,
        Customer_Postal_Code,
        Payment_Method,
        Payment_Status,
        Currency,
        Shipping_Method,
        Warehouse,
        Delivery_Days,
        Estimated_Delivery_Days,
        Delivery_Status,
        Return_Status,
        Order_id,
        Order_Date,
        Order_Time,
        Order_Status,
        Sales_Channel,
        Customer_Rating,
        CASE
            WHEN Customer_Rating < 1.00 THEN '1-Star'
            WHEN Customer_Rating < 1.90 THEN '2-Star'
            WHEN Customer_Rating < 3.00 THEN '3-Star'
            WHEN Customer_Rating < 5.00 THEN '4-Star'
            WHEN Customer_Rating >= 5.00 THEN '5-Star'
            ELSE 'No_star'
        END AS Star_Ratings

    FROM Order_Ranked
    WHERE RN = 1
),
--SELECT *
--FROM ORDER_INFORMATION

SALES_CATALOGUE AS
(
    -- Keep order-item records as they are.
    -- An order can legitimately contain multiple products.
    SELECT
        oi.Order_id,
        oi.Product_id,
        oi.Quantity,
        oi.Unit_Price AS Sales_Unit_Price,
        oi.Discount_Percentage,
        oi.Discount_Amount,
        ROUND(oi.Gross_Sales,2) AS Gross_sales,
        oi.Tax_Amount,
        oi.Shipping_Cost,
        oi.Net_Sales,
        oi.Product_Cost AS Sales_Product_Cost,
        oi.Profit
    FROM order_items oi
),
--SELECT *
--FROM SALES_CATALOGUE

Product_Ranked AS     -- Keep one product record per Product_id
(
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Product_id ORDER BY Product_Name,Product_Category,Brand,Supplier) AS RN
FROM product_catalog 
),

PRODUCT_CATALOGUE AS
(
    SELECT
        Product_id,
        Product_Name,
        Product_Category,
        Product_Subcategory,
        Brand,
        Supplier,
        Unit_Price,
        Product_Cost,
        Product_Rating,
        unit_price - Product_Cost AS Profit_Per_Unit
    FROM Product_Ranked
    WHERE RN = 1
),
--SELECT *
--FROM PRODUCT_CATALOGUE

E_COMMERCE_SALES_SUMMARY AS
(
    SELECT
        -- Customer information
        CI.Customer_id,
        CI.Customer_Name,
        CI.Age,
        CI.Age_Category,
        CI.Gender,
        CI.[State],
        CI.Country,
        CI.Code,
        CI.Acquisition_Cost,

        -- Order information
        OI.Order_id,
        OI.Analytics_Customer_Name,
        OI.Customer_Type,
        OI.Customer_Postal_Code,
        OI.Payment_Method,
        OI.Payment_Status,
        OI.Currency,
        OI.Shipping_Method,
        OI.Warehouse,
        OI.Delivery_Days,
        OI.Estimated_Delivery_Days,
        OI.Delivery_Status,
        OI.Return_Status,
        OI.Order_Date,
        OI.Order_Time,
        OI.Order_Status,
        OI.Sales_Channel,
        OI.Customer_Rating,
        OI.Star_Ratings,

        -- Sales Catalogue
        SI.Product_id,
        SI.Quantity,
        SI.Sales_Unit_Price,
        SI.Discount_Percentage,
        SI.Discount_Amount,
        SI.Gross_Sales,
        SI.Tax_Amount,
        SI.Shipping_Cost,
        SI.Net_Sales,
        SI.Sales_Product_Cost,
        SI.Profit,

        -- Calculated order-item values
        SI.Sales_Unit_Price * SI.Quantity
            AS Calculated_Sales_Revenue,
        SI.Sales_Product_Cost * SI.Quantity
            AS Calculated_Product_Cost,

        -- Product information
        PR.Product_Name,
        PR.Product_Category,
        PR.Product_Subcategory,
        PR.Brand,
        PR.Supplier,
        PR.Unit_Price AS Catalogue_Unit_Price,
        PR.Product_Cost AS Catalogue_Product_Cost,
        PR.Product_Rating,
        PR.Profit_Per_Unit

    FROM ORDER_INFORMATION OI

    LEFT JOIN CUSTOMERS_INFORMATION CI
        ON OI.Customer_id = CI.Customer_id

    LEFT JOIN SALES_CATALOGUE SI
        ON OI.Order_id = SI.Order_id

    LEFT JOIN PRODUCT_CATALOGUE PR
        ON SI.Product_id = PR.Product_id
)
SELECT *
FROM E_COMMERCE_SALES_SUMMARY
ORDER BY Order_Date, Order_id, Product_id;


--FINAL TABLE NOT ARRANGED 
END;

exec SP_Ecommerce_summary

