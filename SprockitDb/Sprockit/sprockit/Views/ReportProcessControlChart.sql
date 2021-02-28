/*
 * sprockit.[ReportBatch]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Process control chart data for monitoring dashboard.
 */

CREATE VIEW sprockit.ReportProcessControlChart
AS

SELECT
  e.ExecutionId
, m.MetricName
, r.EndDateTime AS MetricDateTime
, l.LowerControlLimit
, l.Mean
, l.UpperControlLimit
, m.MetricValue
FROM sprockit.Execution e 
  INNER JOIN sprockit.ProcessControlLimits l ON l.ProcessId = e.ProcessId
  INNER JOIN sprockit.Execution r ON r.ProcessId = e.ProcessId
  INNER JOIN sprockit.ProcessMetric m ON m.ExecutionId = r.ExecutionId
WHERE r.[EndStatus] = 'Done'
AND r.EndDateTime > GETUTCDATE() - 30
