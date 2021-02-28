CREATE PROCEDURE [sprockit_LogEvent].[test WHEN @eventSource NULL THEN @eventSource replaced]
AS

-- ARRANGE
DECLARE @message NVARCHAR(MAX) = 'this is the message'
DECLARE @executionId INT = 27
DECLARE @severity TINYINT = 157
DECLARE @eventDateTime DATETIME = '2020-12-18 20:07'
DECLARE @eventSource NVARCHAR(1024) = NULL

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
DECLARE @actual NVARCHAR(1024)
SELECT @actual = EventSource
FROM sprockit.[Event]

EXEC tSQLt.AssertEquals @Expected = 'Not specified', @Actual = @actual
