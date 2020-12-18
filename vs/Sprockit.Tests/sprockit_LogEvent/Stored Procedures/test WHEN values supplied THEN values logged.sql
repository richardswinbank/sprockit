CREATE PROCEDURE [sprockit_LogEvent].[test WHEN values supplied THEN values logged]
AS

-- ARRANGE
DECLARE @message NVARCHAR(MAX) = 'this is the message'
DECLARE @executionId INT = 27
DECLARE @severity TINYINT = 157
DECLARE @eventDateTime DATETIME = '2020-12-18 20:07'
DECLARE @eventSource NVARCHAR(1024) = 'MyEventSource'

EXEC tSQLt.FakeTable @TableName = 'sprockit.Event'

SELECT *
INTO #expected
FROM sprockit.[Event]

INSERT INTO #expected (
  [EventDateTime]
, [Severity]     
, [ExecutionId]  
, [EventSource]  
, [Message]      
) VALUES (
  @eventDateTime
, @severity
, @executionId
, @eventSource
, @message
)

-- ACT
EXEC [sprockit].[LogEvent] 
  @message 		 = @message 
, @executionId 	 = @executionId 
, @severity 	 = @severity 
, @eventDateTime = @eventDateTime
, @eventSource 	 = @eventSource 

-- ASSERT
EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '[sprockit].[Event]'
