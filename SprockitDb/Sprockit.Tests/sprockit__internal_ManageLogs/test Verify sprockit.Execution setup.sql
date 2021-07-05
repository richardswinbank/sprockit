CREATE PROCEDURE sprockit__internal_ManageLogs.[test Verify sprockit.Execution setup]
AS

-- ARRANGE
DECLARE @expected INT = 6;

-- ACT
DECLARE @actual INT = 0;
SELECT 
  @actual = COUNT(*)
FROM sprockit.Execution;

-- ASSERT
EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual;
