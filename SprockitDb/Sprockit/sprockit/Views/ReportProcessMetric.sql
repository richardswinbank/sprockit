/*
 * sprockit.[ReportProcessMetric]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Process metrics for monitoring dashboard.
 */

CREATE VIEW sprockit.ReportProcessMetric
AS

WITH executions AS (
  SELECT 
    ProcessId
  , MAX(ExecutionId) AS ExecutionId
  , MAX(EndDateTime) AS ExecutionDateTime
  FROM sprockit.Execution
  GROUP BY 
    BatchId
  , ProcessId
)
SELECT 
  x.ProcessId
, x.ExecutionDateTime
, e.[Message] AS MetricName
, SUM(e.MetricValue) AS MetricValue
FROM sprockit.[Event] e
  INNER JOIN executions x ON x.ExecutionId = e.ExecutionId
WHERE e.MetricValue IS NOT NULL
GROUP BY 
  x.ProcessId
, e.[Message]
, x.ExecutionDateTime
