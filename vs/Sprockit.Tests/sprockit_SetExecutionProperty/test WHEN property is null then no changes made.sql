﻿CREATE PROCEDURE sprockit_SetExecutionProperty.[test WHEN property is null then no changes made]
AS

-- ARRANGE
DECLARE @executionId INT = 433
DECLARE @propertyName NVARCHAR(50) = NULL
DECLARE @propertyValue NVARCHAR(50) = 'NewValue'

SELECT 
  e.ExecutionId
, t.c.value('@name', 'NVARCHAR(4000)') AS [name]
, t.c.value('@value', 'NVARCHAR(4000)') AS [value]
INTO #expected
FROM [sprockit].[Execution] e
  CROSS APPLY e.ExecutionProperties.nodes('//Properties/Property') t(c)

-- ACT
EXEC sprockit.[LogExecutionProperty] 
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
