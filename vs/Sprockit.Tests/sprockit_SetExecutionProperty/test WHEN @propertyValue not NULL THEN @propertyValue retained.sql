CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN @propertyValue NULL THEN @propertyValue replaced]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'MySecondProperty'
DECLARE @propertyValue NVARCHAR(50) = NULL

SELECT 
  '<null>' AS PropertyValue
INTO #expected

-- validate that property exists
DECLARE @oldValue NVARCHAR(50)
SELECT 
  @oldValue = xp.PropertyValue
FROM sprockit.Execution e
  CROSS APPLY [sprockit].GetExecutionProperty(@propertyName, e.ExecutionProperties) xp
WHERE e.ExecutionId = @executionId
EXEC tSQLt.AssertEquals @Expected = 'value2', @actual = @oldValue, @message = 'Error in test setup'

-- ACT
EXEC sprockit.[SetExecutionProperty] 
  @executionId = @executionId
, @propertyName = @propertyName
, @propertyValue = @propertyValue

-- ASSERT
SELECT xp.*
INTO #actual
FROM sprockit.Execution e
  CROSS APPLY [sprockit].GetExecutionProperty(@propertyName, e.ExecutionProperties) xp
WHERE e.ExecutionId = @executionId

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual'
