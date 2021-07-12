CREATE PROCEDURE sprockit_PrepareNewBatch.[test WHEN run THEN _internal_ManageLogs called once]
AS

-- ARRANGE
DECLARE @processGroup INT = 1

EXEC tSQLt.SpyProcedure 'sprockit._internal_ManageLogs'

DECLARE @expectedCalls INT = 1;
DECLARE @actualCalls INT = 0;

-- ACT
EXEC sprockit.PrepareNewBatch 
  @processGroup = @processGroup

-- ASSERT
SELECT
  @actualCalls = COUNT(*)
FROM sprockit._internal_ManageLogs_SpyProcedureLog;

EXEC tSQLt.AssertEquals
  @Expected = @expectedCalls
, @Actual = @actualCalls
