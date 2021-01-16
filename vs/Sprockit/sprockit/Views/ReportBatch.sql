/*
 * sprockit.[ReportBatch]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Batch details for monitoring dashboard.
 */

CREATE VIEW [sprockit].[ReportBatch] 
AS

WITH execution AS (
  SELECT
    h.BatchId
  , MAX(COALESCE(e.EndDateTime, GETUTCDATE())) AS LastEndDateTime
  FROM sprockit.Execution e
    INNER JOIN sprockit.Handler h ON h.HandlerId = e.HandlerId
  GROUP BY h.BatchId
), batch AS (
  SELECT 
    b.*
  , ROW_NUMBER() OVER (
      PARTITION BY ProcessGroup
      ORDER BY BatchId
    ) AS SeqNo
  FROM sprockit.Batch b
  WHERE DATEADD(DAY, 14, b.StartDateTime) > GETUTCDATE()
)
SELECT 
  batch.BatchId
, batch.ProcessGroup
, CONVERT(NVARCHAR, batch.StartDateTime, 120) + ' - Group ' + CAST(batch.ProcessGroup AS NVARCHAR) + ' - Batch ' + CAST(batch.BatchId AS NVARCHAR) AS BatchName
, batch.StartDateTime
, CASE
    WHEN e.LastEndDateTime < COALESCE(nxt.StartDateTime, GETUTCDATE()) THEN e.LastEndDateTime
    ELSE COALESCE(nxt.StartDateTime, GETUTCDATE())
  END AS EndDateTime
FROM batch
  LEFT JOIN batch nxt 
    ON nxt.ProcessGroup = batch.ProcessGroup
    AND nxt.SeqNo = batch.SeqNo + 1
  LEFT JOIN execution e ON e.BatchId = batch.BatchId