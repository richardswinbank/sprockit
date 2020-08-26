CREATE PROCEDURE sprockit_LogError.[test GIVEN called THEN calls sprockit.LogEvent]
AS

-- ARRANGE
EXEC tSQLt.SpyProcedure 'sprockit.LogEvent'

DECLARE @executionId INT = 123
DECLARE @message NVARCHAR(MAX) = N'My testing error'
DECLARE @errorDateTime DATETIME = '2020-12-24 23:59'
DECLARE @errorSource NVARCHAR(1024) = N'Source of error'

SELECT 
  @executionId   AS executionId  
, @message       AS [message]
, 200 AS severity
, @errorDateTime AS eventDateTime
, @errorSource   AS eventSource
INTO #expected

-- ACT
EXEC sprockit.LogError 
  @executionId = 123
, @message = 'My testing error'
, @errorDateTime = '2020-12-24 23:59'
, @errorSource = 'Source of error'

-- ASSERT
SELECT
  executionId  
, [message]
, severity
, eventDateTime
, eventSource  
INTO #actual
FROM sprockit.LogEvent_SpyProcedureLog

EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
