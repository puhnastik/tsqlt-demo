# tsqlt-demo
tSQLt database testing framework demo/ examples

## setting up a tsqlt-demo project
### Pre-requirements:
1. Microsoft SQL Server (2005 or higher) running
2. User to be able to create/drop database (scrpts will create/update/drop tables, sprocs, views, functions, schemas)

## installing scripts
The easiest way is to use SQL Server Management Studio and run all files one by one:
 - 1_create_db.sql - script that creates a new db, tables, sprocs, functions and views required for testing, the db name is TSQLT_NH_Example see this file to understand system under test
 - 2_configure_db_for_testing.sql - script that configures a db for testing that is required prior to installing tSQLt (enables clr and sets trustworyhy)
 - 3_tSQLt.class.sql - tSQLt installer (you can get it also from https://sourceforge.net/projects/tsqlt/files/latest/download)
 - 4_exInsertCustomerTest.sql - test class - basic example of Fake Table and AssertEqualsTable usage
 - 5_exInsertOrderTest.sql - test class - example of testing constraints, expecting exceptions and expecting no exceptions to be raised
 - 6_exSaleReportTests.sql - test class - example of stubbing the external function call with Fake Function
 - 7_exIsCustomerActiveTests.sql - test class - example of stubbing external sproc call with Spy Procedure
 
## running tsqlt tests
run all tests by calling stored procedure EXEC tSQLt.RunAll
or
alternatively you could install SQL Server Management Studio plugin from Redgate (http://www.red-gate.com/products/sql-development/sql-test/)
