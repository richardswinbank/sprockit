CREATE PROCEDURE [sprockit].[LogExecutionError] (
  @executionId INT
, @message NVARCHAR(MAX)
, @errorDateTime DATETIME = NULL
)
AS

INSERT INTO [sprockit].[ExecutionError] (
  [ExecutionId]
, [Message]
, [ErrorDateTime]
) VALUES (
  @executionId
, @message
, COALESCE(@errorDateTime, GETUTCDATE())
)