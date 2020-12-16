﻿CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN LogPropertyUpdates not set THEN LogEvent not called]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = 'NotSprockitProcessMessage'
DECLARE @severity INT = 200
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

UPDATE sprockit.Process
SET LogPropertyUpdates = 1

UPDATE sprockit.Process
SET LogPropertyUpdates = 0
WHERE ProcessId = 33

EXEC tSQLt.SpyProcedure 'sprockit.LogEvent'

SELECT 
  'Set property "' + @propertyName + '" = ' + @propertyValue AS [message]
, @executionId AS executionId
, QUOTENAME(OBJECT_SCHEMA_NAME(OBJECT_ID('sprockit.SetExecutionProperty'))) + '.' + QUOTENAME(OBJECT_NAME(OBJECT_ID('sprockit.SetExecutionProperty'))) AS eventSource
INTO #expected
WHERE 0 = 1

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
