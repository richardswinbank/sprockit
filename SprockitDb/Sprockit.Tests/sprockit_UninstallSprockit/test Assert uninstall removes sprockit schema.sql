CREATE PROCEDURE sprockit_UninstallSprockit.[test Assert uninstall removes sprockit schema]
AS

DECLARE @dbName SYSNAME = DB_NAME()

-- ACT
EXEC sprockit.UninstallSprockit @databaseName = @dbName

-- ASSERT
SELECT *
INTO #actual
FROM sys.schemas
WHERE [name] = 'sprockit'

EXEC tSQLt.AssertEmptyTable @TableName = '#actual'
