/*
 * [sprockit].[LogEvent]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Log an event.
 */
 
CREATE PROCEDURE [sprockit].[LogEvent] (
  @message NVARCHAR(MAX)
, @executionId INT = NULL
, @severity TINYINT = 0
, @metricValue DECIMAL(19,5) = NULL
, @eventDateTime DATETIME = NULL
, @eventSource NVARCHAR(1024) = NULL
)
AS

INSERT INTO [sprockit].[Event] (
  [Message]
, [ExecutionId]
, MetricValue
, Severity
, [EventDateTime]
, EventSource
) VALUES (
  @message
, @executionId
, @metricValue
, @severity
, COALESCE(@eventDateTime, GETUTCDATE())
, COALESCE(@eventSource, 'Not specified')
)