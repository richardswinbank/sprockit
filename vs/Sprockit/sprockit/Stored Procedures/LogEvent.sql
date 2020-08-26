CREATE PROCEDURE [sprockit].[LogEvent] (
  @message NVARCHAR(MAX)
, @executionId INT = NULL
, @severity TINYINT = 0
, @eventDateTime DATETIME = NULL
, @eventSource NVARCHAR(1024) = NULL
)
AS

INSERT INTO [sprockit].[Event] (
  [Message]
, [ExecutionId]
, Severity
, [EventDateTime]
, EventSource
) VALUES (
  @message
, @executionId
, @severity
, COALESCE(@eventDateTime, GETUTCDATE())
, COALESCE(@eventSource, 'Not specified')
)