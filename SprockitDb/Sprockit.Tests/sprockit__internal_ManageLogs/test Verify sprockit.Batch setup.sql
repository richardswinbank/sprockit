CREATE PROCEDURE sprockit__internal_ManageLogs.[test Verify sprockit.Batch setup]
AS

-- ARRANGE
DECLARE @expected INT = 4;

-- ACT
DECLARE @actual INT = 0;
SELECT 
  @actual = COUNT(*)
FROM sprockit.[Batch];

-- ASSERT
EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual;
