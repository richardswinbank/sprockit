CREATE PROCEDURE sprockit__internal_ManageLogs.[test Verify sprockit.Event setup]
AS

-- ARRANGE
DECLARE @expected INT = 7;

-- ACT
DECLARE @actual INT = 0;
SELECT 
  @actual = COUNT(*)
FROM sprockit.[Event];

-- ASSERT
EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual;
