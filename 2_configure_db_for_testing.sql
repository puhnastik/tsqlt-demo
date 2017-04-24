USE TSQLT_NH_Example;
GO

--configure and install tsqlt
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;

--set trustworyhy
DECLARE @cmd NVARCHAR(MAX);
SET @cmd='ALTER DATABASE ' + QUOTENAME(DB_NAME()) + ' SET TRUSTWORTHY ON;';
EXEC(@cmd);

SET NOCOUNT ON  
EXEC master.dbo.sp_configure 'show advanced options', 1 
RECONFIGURE 
EXEC master.dbo.sp_configure 'xp_cmdshell', 1 
RECONFIGURE 
GO







