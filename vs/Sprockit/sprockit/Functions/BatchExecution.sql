/*
 * sprockit.[BatchExecution]
 * Copyright (c) 2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Report process execution detail for specified batch
 */
 
CREATE FUNCTION [sprockit].[BatchExecution] (
  @batchSeqNo INT
, @processGroup INT
) RETURNS TABLE
AS RETURN

WITH executions AS (
  SELECT
    e.*
  FROM sprockit.Execution e
    INNER JOIN sprockit.Handler h ON h.HandlerId = e.HandlerId
    INNER JOIN (
      SELECT 
        BatchId
      , StartDateTime AS BatchStartDateTime
      , ROW_NUMBER() OVER (
          PARTITION BY ProcessGroup
          ORDER BY BatchId DESC
        ) AS BatchSeqNo
      FROM sprockit.Batch
      WHERE ProcessGroup = @processGroup
    ) b ON b.BatchId = h.BatchId
  WHERE BatchSeqNo = @batchSeqNo
), processes AS (
  SELECT
    p.ProcessId
  , p.ProcessPath
  , p.ProcessType
  , COALESCE(e.IsEnabled, p.IsEnabled) AS IsEnabled
  , e.ExecutionId
  , e.StartDateTime
  , e.EndDateTime
  , CASE
      WHEN e.ExecutionId IS NOT NULL THEN COALESCE(e.EndStatus, 'Running')
      ELSE 'Not run'
    END AS [Status]
  FROM sprockit.Process p
    LEFT JOIN executions e ON e.ProcessId = p.ProcessId
  WHERE p.ProcessGroup = @processGroup
)
SELECT 
  p.*
, ROW_NUMBER() OVER (
    ORDER BY latest.LastStartDateTime DESC
  ) AS OutputOrder
FROM processes p
  INNER JOIN (
    SELECT 
      ProcessId
    , MAX(COALESCE(EndDateTime, StartDateTime, '9000-12-31')) AS LastStartDateTime
    FROM processes
    GROUP BY ProcessId
  ) latest ON latest.ProcessId = p.ProcessId
