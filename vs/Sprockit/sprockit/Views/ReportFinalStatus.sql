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
    BatchId
  , ProcessId
  , COALESCE(EndStatus, 'Running') AS FinalStatus
  , ExecutionId
  FROM sprockit.Execution e
  ORDER BY ROW_NUMBER() OVER (
    PARTITION BY 
      BatchId
    , ProcessId
    ORDER BY ExecutionId DESC
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