CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN @propertyName not reserved and property not exists THEN property added]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'MyNewProperty'
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

SELECT 
  @propertyValue AS PropertyValue
INTO #expected

-- validate that property does not exist
DECLARE @oldValue NVARCHAR(50)
SELECT 
  @oldValue = xp.PropertyValue
FROM sprockit.Execution e
  CROSS APPLY [sprockit].GetExecutionProperty(@propertyName, e.ExecutionProperties) xp
WHERE e.ExecutionId = @executionId
EXEC tSQLt.AssertEquals @Expected = NULL, @actual = @oldValue, @message = 'Error in test setup'

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
