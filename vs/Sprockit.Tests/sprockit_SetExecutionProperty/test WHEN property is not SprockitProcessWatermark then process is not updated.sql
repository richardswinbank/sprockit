CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN property is not SprockitProcessWatermark then process is not updated]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'MySecondProperty'
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

SELECT 
  ProcessId
, [CurrentWatermark]
INTO #expected
FROM sprockit.Process

-- ACT
EXEC sprockit.[LogExecutionProperty] 
  @executionId = @executionId
, @propertyName = @propertyName
, @propertyValue = @propertyValue

-- ASSERT
SELECT 
  ProcessId
, [CurrentWatermark]
INTO #actual
FROM sprockit.Process

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual'
