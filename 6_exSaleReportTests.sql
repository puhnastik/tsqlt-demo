USE TSQLT_NH_Example;
GO

EXEC tSQLt.NewTestClass 'exSalesReportViewTests'
GO

-- create the Fake Function
IF EXISTS (SELECT * FROM sysobjects WHERE name='Fake_ProfitComplexFunction' and xtype='FN')
	DROP FUNCTION [Example].[Fake_ProfitComplexFunction]
GO

CREATE FUNCTION [Example].[Fake_ProfitComplexFunction] (@OrdersTotal float)
RETURNS DECIMAL(10, 2)
AS
BEGIN
	RETURN 21.11;
END
GO 

--
-- example of a Fake Function
-- SalesReport view is calling out to a copmlex function in order to generate Profit values, as long as testing of function itself
-- is out of the scope of the view unit tests, we create a FakeFunction that will return constant values
--
CREATE PROCEDURE exSalesReportViewTests.[test check that view sales report returns revenue and profit]
AS
BEGIN
	--Arrange
	EXEC tSQLt.FakeTable 'Example.Customers';
	EXEC tSQLt.FakeTable 'Example.Orders';
	EXEC tSQLt.FakeFunction 'Example.ProfitComplexFunction', 'Example.Fake_ProfitComplexFunction'

	--Act
	INSERT INTO [Example].[Orders] (OrderID, OrderType, Value, CustomerID) VALUES (1, 1, 10.5, 1), (2, 1, 20.1, 2), (3, 2, 10, 2);

	SELECT TOP(0) *
      INTO #EXPECTED
      FROM [Example].[SalesReport]

	INSERT INTO #EXPECTED VALUES (1, 30.6, 21.11);
	INSERT INTO #EXPECTED VALUES (2, 10, 21.11);

	--Assert
	EXEC tSQLt.AssertEqualsTable #EXPECTED, 'Example.SalesReport', 'Data was not inserted as expected';

END
GO