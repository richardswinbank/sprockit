CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN @propertyName SprockitProcessWarning THEN LogEvent called]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'SprockitProcessWarning'
DECLARE @severity INT = 100
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

EXEC tSQLt.SpyProcedure 'sprockit.LogEvent'

SELECT 
  @propertyValue AS [message]
, @executionId AS executionId
, @severity AS severity
INTO #expected

-- ACT
EXEC sprockit.[SetExecutionProperty] 
  @executionId = @executionId
, @propertyName = @propertyName
, @propertyValue = @propertyValue

-- ASSERT
SELECT 
  *
INTO #actual
FROM sprockit.LogEvent_SpyProcedureLog

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual'
