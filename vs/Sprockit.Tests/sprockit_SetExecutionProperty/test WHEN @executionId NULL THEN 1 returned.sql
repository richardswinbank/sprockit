CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN @executionId NULL THEN 1 returned]
AS

-- ARRANGE
DECLARE @executionId INT = NULL
DECLARE @propertyName NVARCHAR(50) = 'SomeProperty'
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

EXEC tSQLt.SpyProcedure 'sprockit.LogEvent'

DECLARE @expected INT = 1

-- ACT
DECLARE @actual INT = 0

EXEC @actual = sprockit.[SetExecutionProperty] 
  @executionId = @executionId
, @propertyName = @propertyName
, @propertyValue = @propertyValue

-- ASSERT
EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual
