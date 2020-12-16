CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN @propertyName not reserved and @executionId not exists THEN Execution not updated]
AS

-- ARRANGE
DECLARE @executionId INT = 435
DECLARE @propertyName NVARCHAR(50) = 'MyNewProperty'
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

SELECT 
  e.ExecutionId
, t.c.value('@name', 'NVARCHAR(4000)') AS [name]
, t.c.value('@value', 'NVARCHAR(4000)') AS [value]
INTO #expected
FROM [sprockit].[Execution] e
  CROSS APPLY e.ExecutionProperties.nodes('//Properties/Property') t(c)

-- ACT
EXEC sprockit.[SetExecutionProperty] 
  @executionId = @executionId
, @propertyName = @propertyName
, @propertyValue = @propertyValue

-- ASSERT
SELECT 
  e.ExecutionId
, t.c.value('@name', 'NVARCHAR(4000)') AS [name]
, t.c.value('@value', 'NVARCHAR(4000)') AS [value]
INTO #actual
FROM [sprockit].[Execution] e
  CROSS APPLY e.ExecutionProperties.nodes('//Properties/Property') t(c)

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual'
