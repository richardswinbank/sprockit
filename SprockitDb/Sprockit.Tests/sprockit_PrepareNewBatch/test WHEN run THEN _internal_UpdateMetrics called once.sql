CREATE PROCEDURE sprockit_PrepareNewBatch.[test WHEN run THEN _internal_UpdateMetrics called once]
AS

-- ARRANGE
DECLARE @processGroup INT = 1

EXEC tSQLt.SpyProcedure 'sprockit._internal_UpdateMetrics'

DECLARE @expectedCalls INT = 1;
DECLARE @actualCalls INT = 0;
DECLARE @processGroupParam INT = 0;

-- ACT
EXEC sprockit.PrepareNewBatch 
  @processGroup = @processGroup

-- ASSERT
SELECT
  @actualCalls = COUNT(*)
, @processGroupParam = MAX(processGroup)
FROM sprockit._internal_UpdateMetrics_SpyProcedureLog;

EXEC tSQLt.AssertEquals
  @Expected = @expectedCalls
, @Actual = @actualCalls

EXEC tSQLt.AssertEquals
  @Expected = @processGroup
, @Actual = @processGroupParam
