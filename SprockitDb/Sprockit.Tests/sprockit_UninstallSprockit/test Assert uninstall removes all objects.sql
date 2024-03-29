CREATE PROCEDURE sprockit_UninstallSprockit.[test Assert uninstall removes all objects]
AS

DECLARE @dbName SYSNAME = DB_NAME()

-- ACT
EXEC sprockit.UninstallSprockit @databaseName = @dbName

-- If the uninstall script does not remove all objects, this will fail 
-- because schema removal fails (schema removal is tested separately).
