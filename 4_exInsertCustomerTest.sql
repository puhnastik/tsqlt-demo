USE TSQLT_NH_Example;
GO

EXEC tSQLt.NewTestClass 'exInsertCustomerTests'
GO

--
-- example of tSQLt assert
--
CREATE PROCEDURE exInsertCustomerTests.[test example simple assert]
AS
BEGIN
	EXEC tSQLt.AssertEquals 'expected', 'actual', 'error message';

END
GO

--
-- example of tSQLt FakeTable and AssertEqualsTable
--
CREATE PROCEDURE exInsertCustomerTests.[test that new customer can be created]
AS
BEGIN
	--Arrange
	DECLARE @CustomerID int = 1;
	DECLARE @FirstName varchar(20) = 'Willow';
	DECLARE @LastName varchar(20) = 'TheCat';

	SELECT   @CustomerID AS 'CustomerID', @FirstName AS 'FirstName', @LastName AS 'LastName'
    INTO #EXPECTED

	EXEC tSQLt.FakeTable 'Example.Customers', @Identity=1;

	-- Act
	DECLARE @Result int = 1;
	EXEC @Result = [Example].[exInsertCustomer] @FirstName, @LastName;

	-- Assert
    EXEC tSQLt.assertEquals 0, @Result;

	DECLARE @Count int = 0;
    SET @Count = (Select count(*) from Example.Customers);
    EXEC tSQLt.assertEquals 1, @Count, 'Number of records after insert is incorrect';

	EXEC tSQLt.AssertEqualsTable #EXPECTED, 'Example.Customers', 'Data was not inserted as expected';

END
GO


