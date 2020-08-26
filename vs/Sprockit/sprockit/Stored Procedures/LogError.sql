
CREATE PROCEDURE [sprockit].[LogError] (
  @executionId INT
, @message NVARCHAR(MAX)
, @errorDateTime DATETIME = NULL
, @errorSource NVARCHAR(1024) = NULL
)
AS

EXEC [sprockit].[LogEvent]
  @message = @message
, @executionId = @executionId
, @severity = 200
, @eventDateTime = @errorDateTime
, @eventSource = @errorSource