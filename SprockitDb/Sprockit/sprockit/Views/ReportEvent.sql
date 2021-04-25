/*
 * sprockit.[ReportEvent]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Event details for monitoring dashboard.
 */

CREATE VIEW [sprockit].[ReportEvent]
AS

SELECT 
  x.BatchId
, e.EventId
, e.EventDateTime
, e.Severity
, CASE 
    WHEN e.Severity < 100 THEN 'Information'
    WHEN e.Severity < 200 THEN 'Warning'
    ELSE 'Error'
  END AS SeverityClass
, x.ExecutionId
, p.ProcessPath
, e.[EventSource]
, e.[Message]
, e.MetricValue
FROM sprockit.[Event] e
  INNER JOIN sprockit.Execution x ON x.ExecutionId = e.ExecutionId
  INNER JOIN sprockit.Process p ON p.ProcessId = x.ProcessId