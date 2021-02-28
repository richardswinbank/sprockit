/*
 * sprockit.[LogProcessMetric] 
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Log a process metric & warn if it exceeds control limits
 */

CREATE PROCEDURE [sprockit].LogProcessMetric (
  @executionId INT
, @metricName NVARCHAR(128)
, @metricValue DECIMAL(19,5)
)
AS

INSERT INTO [sprockit].ProcessMetric (
  ExecutionId
, MetricName
, MetricValue
) VALUES (
  @executionId
, @metricName
, @metricValue
);

DECLARE @message NVARCHAR(255) = N'';

SELECT
  @message = 'Metric [' + m.MetricName + '] exceeds control limit'
FROM sprockit.ProcessMetric m
  INNER JOIN sprockit.Execution e ON e.ExecutionId = m.ExecutionId
  INNER JOIN sprockit.ProcessControlLimits l ON l.ProcessId = e.ProcessId
WHERE e.ExecutionId = @executionId
AND e.EndStatus = 'Done'
AND m.MetricValue NOT BETWEEN l.LowerControlLimit AND l.UpperControlLimit;

IF LEN(@message) > 0
  EXEC sprockit.LogEvent 
    @message = @message
  , @eventSource = 'sprockit.LogProcessMetric'
  , @executionId = @executionId
  , @severity = 100  -- warning
