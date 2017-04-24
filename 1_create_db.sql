--
-- Create clean database
--
USE master;
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name='TSQLT_NH_Example')
BEGIN
	PRINT 'Dropping the database'	
	DROP DATABASE TSQLT_NH_Example
END

PRINT 'Creating the database'	
CREATE DATABASE TSQLT_NH_Example;
USE TSQLT_NH_Example;
GO

CREATE SCHEMA Example;
GO


--
-- Create tables
--
PRINT 'Creating Customers table'
CREATE TABLE [Example].[Customers](
	CustomerID int NOT NULL IDENTITY(1,1),
	FirstName varchar(20) NOT NULL,
	LastName varchar(20),
	PRIMARY KEY (CustomerID));
GO

PRINT 'Creating Orders table'
CREATE TABLE [Example].[Orders] (
	OrderID int NOT NULL IDENTITY(1,1),
	OrderType int NOT NULL,
	Value float,
	CustomerID int NOT NULL,
	PRIMARY KEY (OrderID),
	CONSTRAINT CHK_OrderValue CHECK (Value > 0),
	CONSTRAINT FK_Orders_Customers FOREIGN KEY  (CustomerID) REFERENCES [Example].[Customers](CustomerID));
GO


PRINT 'Creating Stored Procedures, Funtions and Views';
GO


--
-- Stored procedures will be used for examples of basic tSQLt functionality,
-- such as test class, tests, asserts, expectations, fake tables and apply constraint
--
CREATE PROCEDURE [Example].[exInsertCustomer]
	@FirstName varchar(20),
	@LastName varchar(20)
AS	
	INSERT INTO [Example].[Customers](FirstName, LastName)
		VALUES (@FirstName, @LastName);
GO

CREATE PROCEDURE [Example].[exInsertOrder]
	@OrderType int,
	@Value float,
	@CustomerID int 
AS
	INSERT INTO [Example].[Orders](OrderType, Value, CustomerID)
		VALUES (@OrderType, @Value, @CustomerID);
GO


--
-- The functions and view are used for the fake function example
--
CREATE FUNCTION [Example].[ProfitComplexFunction] (@OrdersTotal float)
RETURNS DECIMAL(10, 2)
AS
BEGIN
	 RETURN cast('Error happened here.' as DECIMAL(10, 2));
END
GO 

CREATE VIEW [Example].[SalesReport]
AS
SELECT OrderType, Sum(Value) AS Revenue, [Example].[ProfitComplexFunction](Sum(Value)) as Profit
FROM  [Example].[Orders] GROUP BY OrderType;
GO


--
-- Next two procedures will be used for spy procedure example
--
CREATE PROCEDURE [Example].[exGetNumberOfFailedLogins]
	@CustomerID int,
	@NumberOfFailedLogins int OUTPUT
AS
	-- This procedure does something to return a number of failed logins for a customer
GO

CREATE PROCEDURE [Example].[exIsCustomerActive]
	@CustomerID int
AS
BEGIN
	DECLARE @NumberOfFailedLogins int;

	EXEC  [Example].[exGetNumberOfFailedLogins] @CustomerID, @NumberOfFailedLogins = @NumberOfFailedLogins OUT;

	IF @NumberOfFailedLogins > 3
		RETURN -1;
	ELSE 
		RETURN 0;
END
GO








