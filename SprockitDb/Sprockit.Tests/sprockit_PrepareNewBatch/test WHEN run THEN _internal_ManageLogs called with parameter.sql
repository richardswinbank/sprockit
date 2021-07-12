CREATE PROCEDURE sprockit_PrepareNewBatch.[test WHEN run THEN _internal_ManageLogs called with parameter]
AS

-- ARRANGE
DECLARE @processGroup INT = 762353746;
DECLARE @expected INT = @processGroup;

EXEC tSQLt.SpyProcedure 'sprockit._internal_UpdateMetrics'

DECLARE @actual INT = 0;

-- ACT
EXEC sprockit.PrepareNewBatch 
  @processGroup = @processGroup;

-- ASSERT
SELECT
  @actual = processGroup
FROM sprockit._internal_UpdateMetrics_SpyProcedureLog;

EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual;
