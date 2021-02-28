CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN @propertyName SprockitProcessWatermark THEN Execution not updated]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'SprockitProcessWatermark'
DECLARE @propertyValue NVARCHAR(50) = 'Message'

SELECT 
  @propertyValue AS PropertyValue
INTO #expected
WHERE 0 = 1

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
