CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN property is SprockitProcessWatermark then process is updated]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'SprockitProcessWatermark'
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

SELECT 
  ProcessId
, CASE ProcessId WHEN 33 THEN @propertyValue ELSE [CurrentWatermark] END AS [CurrentWatermark]
INTO #expected
FROM sprockit.Process

-- ACT
EXEC sprockit.[SetExecutionProperty] 
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
