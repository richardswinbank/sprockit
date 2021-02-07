/*
 * sprockit.[ReportExecution]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Execution details for monitoring dashboard.
 */

CREATE VIEW sprockit.ReportExecution
AS

WITH evt AS (
  SELECT
    ExecutionId
  , SUM(CASE WHEN Severity BETWEEN 100 AND 199 THEN 1 ELSE 0 END) AS Warnings
  , SUM(CASE WHEN Severity >= 200 THEN 1 ELSE 0 END) AS Errors
  FROM sprockit.[Event]
  GROUP BY ExecutionId
)
SELECT
  x.BatchId
, p.ProcessGroup
, x.ExecutionId
, x.ExternalHandlerId
, x.ProcessId
, p.ProcessPath
, p.ProcessType
, pt.[Description] AS ProcessTypeName
, x.IsEnabled
, pt.HasHandler
, x.StartDateTime
, x.EndDateTime
, x.EndStatus
, COALESCE(evt.Warnings, 0) AS Warnings
, CASE 
    WHEN evt.Errors > 0 THEN evt.Errors
	WHEN x.EndStatus = 'Errored' THEN 1
	ELSE 0
  END AS Errors
FROM sprockit.Execution x
  INNER JOIN sprockit.Process p ON p.ProcessId = x.ProcessId
  INNER JOIN sprockit.ProcessType pt ON pt.ProcessType = p.ProcessType
  LEFT JOIN evt ON evt.ExecutionId = x.ExecutionId
