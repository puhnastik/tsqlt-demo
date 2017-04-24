USE TSQLT_NH_Example;
GO

EXEC tSQLt.NewTestClass 'exInsertOrderTests'
GO

--
-- example of a Fake table behavior - constraints are not applied and have to be tested separately
-- here the value == 0 can be inserted ignoring check and customer id is a foreign key for non-existing customer
--
CREATE PROCEDURE exInsertOrderTests.[test check that order can be inserted]
AS
BEGIN
	--Arrange
	DECLARE @OrderType int = 1;
	DECLARE @OrderID int = 1;
	DECLARE @Value float = 0;
	DECLARE @CustomerID int = 1;

	SELECT @OrderType AS 'OrderType', @OrderID AS 'OrderID', @Value AS 'Value', @CustomerID AS 'CustomerID'
	INTO #EXPECTED;

	EXEC tSQLt.FakeTable 'Example.Orders', @Identity=1;

	--Act
	DECLARE @Result int = 1;
	EXEC @Result = [Example].[exInsertOrder] @OrderType, @Value, @CustomerID;

	--Assert
	EXEC tSQLt.AssertEquals 0, @Result;

	EXEC tSQLt.AssertEqualsTable #EXPECTED, 'Example.Orders', 'Data was not inserted as expected';

END
GO

--
-- example for Apply Constraint for CHECK on 'value'
--
CREATE PROCEDURE exInsertOrderTests.[test that check constraint prevents insert value == 0]
AS
BEGIN
	--Arrange
	DECLARE @OrderType int = 1;
	DECLARE @OrderID int = 1;
	DECLARE @Value float = 0;
	DECLARE @CustomerID int = 1;

	SELECT @OrderID AS 'OrderID', @OrderType AS 'OrderType', @Value AS 'Value', @CustomerID AS 'CustomerID'
	INTO #EXPECTED;

	EXEC tSQLt.FakeTable 'Example.Orders', @Identity=1;
	EXEC tSQLt.ApplyConstraint 'Example.Orders', 'CHK_OrderValue';

	--Act/Assert
	EXEC tSQLt.ExpectException @Message = 'The INSERT statement conflicted with the CHECK constraint "CHK_OrderValue".
											The conflict occurred in database "TSQLT_NH_Example", table "Example.Orders", column "Value"';
	EXEC [Example].[exInsertOrder] @OrderType, @Value, @CustomerID;

END
GO

--
-- example of Apply Constraint on FOREIGN KEY & Expect Exception
-- 
CREATE PROCEDURE exInsertOrderTests.[test that foreign key constraint prevents insert of orphaned rows ]
AS
BEGIN
	--Arrange
	DECLARE @OrderType int = 1;
	DECLARE @OrderID int = 1;
	DECLARE @Value float = 10;
	DECLARE @CustomerID int = 1;

	SELECT @OrderID AS 'OrderID', @OrderType AS 'OrderType', @Value AS 'Value', @CustomerID AS 'CustomerID'
	INTO #EXPECTED;

	EXEC tSQLt.FakeTable 'Example.Orders', @Identity=1;
	EXEC tSQLt.ApplyConstraint 'Example.Orders', 'FK_Orders_Customers';

	--Act/Assert
	EXEC tSQLt.ExpectException @Message = 'The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Orders_Customers". 
											The conflict occurred in database "TSQLT_NH_Example", table "Example.Customers", column "CustomerID"';
	EXEC [Example].[exInsertOrder] @OrderType, @Value, @CustomerID;

END
GO

--
-- example of Apply Constraint on FOREIGN KEY & Expect No Exception
--
CREATE PROCEDURE exInsertOrderTests.[test that foreign key constraint allows insert of non-orphaned rows]
AS
BEGIN
	--Arrange
	DECLARE @OrderType int = 1;
	DECLARE @Value float = 10;
	DECLARE @CustomerID int = 1;
	DECLARE @FirstName varchar(20) = 'Willow';
	DECLARE @LastName varchar(20) = 'TheCat';

	EXEC tSQLt.FakeTable 'Example.Customers';
	EXEC tSQLt.FakeTable 'Example.Orders';
	
	EXEC tSQLt.ApplyConstraint 'Example.Orders', 'FK_Orders_Customers';
	
	INSERT INTO [Example].[Customers] (CustomerID, FirstName, LastName) VALUES (@CustomerID, @FirstName, @LastName);

	--Act/Assert
	EXEC tSQLt.ExpectNoException;
	EXEC [Example].[exInsertOrder] 	@OrderType, @Value, @CustomerID;

END
GO

