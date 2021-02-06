/*
 * sprockit.[PrepareBatchRestart]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Prepare Sprockit processes to restart the current batch for a specified process group
 */
 
CREATE PROCEDURE [sprockit].[PrepareBatchRestart] (
  @processGroup INT
)
AS

-- delete reservations from last attempt
DELETE r
FROM sprockit.Reservation r
  INNER JOIN sprockit.Process p ON p.ProcessId = r.ProcessId
WHERE p.ProcessGroup = @processGroup

-- clear up after crashed handlers
UPDATE h
SET EndDateTime = GETUTCDATE()
  , [Status] = 'Unknown'
FROM sprockit.Handler h
  INNER JOIN sprockit.Batch b ON b.BatchId = h.BatchId
WHERE h.EndDateTime IS NULL
AND b.ProcessGroup = @processGroup

-- clear up after crashed handlers' executions
UPDATE e
SET EndDateTime = GETUTCDATE()
  , [EndStatus] = 'Unknown'
FROM sprockit.Execution e
  INNER JOIN sprockit.Handler h ON h.HandlerId = e.HandlerId
  INNER JOIN sprockit.Batch b ON b.BatchId = h.BatchId
WHERE e.EndDateTime IS NULL
AND b.ProcessGroup = @processGroup

-- reset process statuses
UPDATE sprockit.Process
SET [Status] = 
  CASE [Status]
    WHEN 'Blocked' THEN 'Not ready'
    ELSE 'Ready'
  END
, LastStatusUpdate = GETUTCDATE()
, ErrorCount = 0
WHERE [Status] IN (
  'Running'
, 'Errored'
, 'Stopped'
, 'Blocked'
)
AND ProcessGroup = @processGroup

SELECT TOP 1 
  BatchId
FROM sprockit.Batch
WHERE ProcessGroup = @processGroup
ORDER BY StartDateTime DESC
