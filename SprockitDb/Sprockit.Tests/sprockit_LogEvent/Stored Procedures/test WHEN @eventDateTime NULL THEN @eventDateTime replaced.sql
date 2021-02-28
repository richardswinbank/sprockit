CREATE PROCEDURE [sprockit_LogEvent].[test WHEN @eventDateTime NULL THEN @eventDateTime replaced]
AS

-- ARRANGE
DECLARE @message NVARCHAR(MAX) = 'this is the message'
DECLARE @executionId INT = 27
DECLARE @severity TINYINT = 157
DECLARE @eventDateTime DATETIME = NULL
DECLARE @eventSource NVARCHAR(1024) = 'MyEventSource'

EXEC tSQLt.FakeTable 
  @TableName = 'sprockit.Event' 
, @Defaults = 1

DECLARE @expectedAfter DATETIME = GETUTCDATE()

-- ACT
EXEC [sprockit].[LogEvent] 
  @message 		 = @message 
, @executionId 	 = @executionId 
, @severity 	 = @severity 
, @eventDateTime = @eventDateTime
, @eventSource 	 = @eventSource 

-- ASSERT
DECLARE @actual DATETIME
SELECT @actual = EventDateTime
FROM sprockit.[Event]

IF COALESCE(@actual, '1900-01-01') < @expectedAfter
  EXEC tSQLt.Fail 