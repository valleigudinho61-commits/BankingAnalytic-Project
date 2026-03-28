create database banking_db;
use banking_db;
/*create table banking_transaction (Customer_ID text,
Customer_Name text,
Account_Number text,
Transaction_Date text,
Transaction_Type text,
Amount_Balance text,
Description_Branch text,
Transaction_Method text,
Currency text,
Bank_Name text
); */

CREATE TABLE banking_transaction_clean (
Customer_ID VARCHAR(50),
Customer_Name VARCHAR(100),
Account_Number BIGINT,
Transaction_Date DATE,
Transaction_Type VARCHAR(20),
Amount DECIMAL(10,2),
Balance DECIMAL(10,2),
Description VARCHAR(255),
Branch VARCHAR(100),
Transaction_Method VARCHAR(50),
Currency VARCHAR(10),
Bank_Name VARCHAR(100)
);

SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/Users/pavan/Downloads/Bank DA project ELR/Debit and Credit banking_data.csv ' 
INTO TABLE banking_transaction_clean
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select *from banking_transaction_clean;

/*SELECT COUNT(*) FROM banking_transaction_clean; */

/* Analysis 1: Credit vs Debit Analysis */
SELECT Transaction_Type, SUM(Amount)
FROM banking_transaction_clean
GROUP BY Transaction_Type;

/* Analysis 2: Bank-wise Transactions */
SELECT Bank_Name, COUNT(*)
FROM banking_transaction_clean
GROUP BY Bank_Name;

/* Analysis 3: Customer-wise Transaction Amount */
SELECT Customer_Name, SUM(Amount)
FROM banking_transaction_clean
GROUP BY Customer_Name;

/* Analysis 4: Monthly Transaction Analysis */
SELECT MONTH(Transaction_Date), SUM(Amount)
FROM banking_transaction_clean
GROUP BY MONTH(Transaction_Date);

/* Analysis 5: Transaction Method Analysis */
SELECT Transaction_Method, COUNT(*)
FROM banking_transaction_clean
GROUP BY Transaction_Method;

/* KPI 1: Total Transaction Amount */
SELECT SUM(Amount) as Total_Amount FROM banking_transaction_clean;

/*KPI 2: Total Credit Amount */
SELECT SUM(Amount) as Total_Credit
FROM banking_transaction_clean
WHERE Transaction_Type='Credit';

/*KPI 3: Total debit Amount */
SELECT SUM(Amount) as Total_Debit
FROM banking_transaction_clean
WHERE Transaction_Type='Debit';

/* KPI 4: Total Customers */
SELECT COUNT(DISTINCT Customer_ID)as Total_Customers
FROM banking_transaction_clean;

/* KPI 5: Average Transaction Amount */
SELECT AVG(Amount)
FROM banking_transaction_clean;

#AVG Amount
select round(avg(amount),0)as avg_transaction from banking_transaction_clean;

# (SUB QUERY) Find transactions above average amount.
select customer_name,Amount from banking_transaction_clean where Amount >
(select round(avg(Amount),0)as avg_transaction from banking_transaction_clean)
order by Amount asc;

-- WINDOWS FUNCTION --
#Rank transactions by Amount (highest first).
select customer_name,amount, dense_rank() over(order by amount desc)drnk from banking_transaction_clean;

/* Creating View */
CREATE VIEW bank_summary AS
SELECT Bank_Name, COUNT(*), SUM(Amount)
FROM banking_transaction_clean
GROUP BY Bank_Name;
select *from bank_summary;

-- STORED PROCEDURE --
#Procedure to fetch transactions by date range
call banking_db.transaction_info('2024-01-01', '2024-12-31');


