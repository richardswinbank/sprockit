CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN property is null then return status is 1]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = NULL
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

DECLARE @expected INT = 1
DECLARE @actual INT = 0

-- ACT
EXEC @actual = sprockit.[LogExecutionProperty] 
  @executionId = @executionId
, @propertyName = @propertyName
, @propertyValue = @propertyValue

-- ASSERT
EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual
