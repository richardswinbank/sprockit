CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN @propertyName NULL THEN @propertyName replaced]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = NULL
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

EXEC tSQLt.SpyProcedure 'sprockit.LogEvent'

SELECT 
  @propertyValue AS [message]
, @executionId AS executionId
, 0 AS severity  -- NULL @propertyName treated should be handled as SprockitProcessInformation
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
