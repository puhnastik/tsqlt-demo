USE TSQLT_NH_Example;
GO

EXEC tSQLt.NewTestClass 'exIsCustomerActiveTests';
GO

--
-- example of a Spy Procedure that returns hard-coded value
-- SpyProcedure is used to spy on the [exGetNumberOfFailedLogins] sproc and return a constant number of failed logins
-- 
CREATE PROCEDURE exIsCustomerActiveTests.[test that exIsCustomerActiveTests returns 0 if customer is active]
AS
BEGIN
	--Arrange
	DECLARE @CustomerID int = 1;
	DECLARE @NumberOfFailedLogins int = 10;

	EXEC tSQLt.SpyProcedure  'Example.exGetNumberOfFailedLogins', 'SET @NumberOfFailedLogins = 2';
	
	--Act
	DECLARE @Result int = 1;
	EXEC @Result =  [Example].[exIsCustomerActive] @CustomerID;

	--Assert
	EXEC tSQLt.AssertEquals 0, @Result

END
GO