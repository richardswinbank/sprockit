CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN property is not null then event is logged]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'MySecondProperty'
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

EXEC tSQLt.SpyProcedure 'sprockit.LogEvent'

SELECT 
  'Set property "' + @propertyName + '" = ' + @propertyValue AS [message]
, @executionId AS executionId
, '[sprockit].[SetExecutionProperty]' AS eventSource
INTO #expected

-- ACT
EXEC sprockit.SetExecutionProperty 
  @executionId = @executionId
, @propertyName = @propertyName
, @propertyValue = @propertyValue

-- ASSERT
SELECT 
  [message]
, executionId
, eventSource
INTO #actual
FROM sprockit.LogEvent_SpyProcedureLog

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual'
