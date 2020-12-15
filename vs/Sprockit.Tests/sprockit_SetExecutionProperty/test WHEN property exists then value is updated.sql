CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN property exists then value is updated]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'MySecondProperty'
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

SELECT 
  e.ExecutionId
, t.c.value('@name', 'NVARCHAR(4000)') AS [name]
, t.c.value('@value', 'NVARCHAR(4000)') AS [value]
INTO #expected
FROM [sprockit].[Execution] e
  CROSS APPLY e.ExecutionProperties.nodes('//Properties/Property') t(c)

UPDATE e
SET [value] = @propertyValue
FROM #expected e
WHERE ExecutionId = @executionId
AND [name] = @propertyName

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

