CREATE PROCEDURE [dbo].InsertExec(@insertInto nvarchar(255), @exec nvarchar(max))
AS EXTERNAL NAME [SprockitTests].[SprockitTests.ClrStoredProcedures].SendResultsToTable
