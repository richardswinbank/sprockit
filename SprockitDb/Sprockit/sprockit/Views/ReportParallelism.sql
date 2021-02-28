/*
 * sprockit.[ReportFinalStatus]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Process parallelisation information for monitoring dashboard.
 */

CREATE VIEW sprockit.ReportParallelism
AS

WITH [24h] AS (
  SELECT TOP 1440
    ROW_NUMBER() OVER (ORDER BY [object_id]) - 1 AS [Minute]
  FROM sys.all_columns
)
SELECT
  b.BatchId
, DATEADD(MINUTE, [24h].[Minute], b.StartDateTime) AS PollDateTime
, SUM(CASE WHEN e.BatchId IS NULL THEN 0 ELSE 1 END) AS RunningProcesses
FROM sprockit.ReportBatch b
  INNER JOIN [24h] ON DATEADD(MINUTE, [24h].[Minute], b.StartDateTime) < b.EndDateTime
  LEFT JOIN sprockit.Execution e ON DATEADD(MINUTE, [24h].[Minute], b.StartDateTime) BETWEEN e.StartDateTime AND COALESCE(e.EndDateTime, b.EndDateTime)
GROUP BY 
  b.BatchId
, DATEADD(MINUTE, [24h].[Minute], b.StartDateTime)