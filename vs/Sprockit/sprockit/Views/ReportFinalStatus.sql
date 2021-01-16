/*
 * sprockit.[ReportFinalStatus]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Process final status details for monitoring dashboard.
 */

CREATE VIEW [sprockit].[ReportFinalStatus] 
AS

WITH [status] AS (
  SELECT TOP 1 WITH TIES
    h.BatchId
  , e.ProcessId
  , COALESCE(e.EndStatus, 'Running') AS FinalStatus
  , e.ExecutionId
  FROM sprockit.Execution e
    INNER JOIN sprockit.Handler h ON h.HandlerId = e.HandlerId
  ORDER BY ROW_NUMBER() OVER (
    PARTITION BY 
      h.BatchId
    , e.ProcessId
    ORDER BY e.ExecutionId DESC
  )
)
SELECT 
  b.BatchId
, p.ProcessId
, COALESCE(s.FinalStatus, 'Not run') AS FinalStatus
, s.ExecutionId
FROM sprockit.Process p
  INNER JOIN sprockit.Batch b ON b.ProcessGroup = p.ProcessGroup
  LEFT JOIN [status] s 
    ON s.BatchId = b.BatchId
    AND s.ProcessId =p.ProcessId