/*
 * sprockit.[PrepareBatchRestart]
 * Copyright (c) 2015-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Prepare Sprockit processes to restart the current batch for a specified process group
 */
 
CREATE PROCEDURE [sprockit].[PrepareBatchRestart] (
  @processGroup INT
, @externalManagerId NVARCHAR(1024) = NULL
)
AS

--- determine batch ID 
DECLARE @batchId INT
DECLARE @msg NVARCHAR(255)

SELECT TOP 1
  @batchId = BatchId
, @msg = 'Process manager started for batch ID ' + CAST(@batchId AS VARCHAR) 
    + COALESCE(' (external ID ' + @externalManagerId + ')', '')
FROM sprockit.Batch
WHERE ProcessGroup = @processGroup
ORDER BY [CreatedDateTime] DESC;

-- Log restart
EXEC sprockit.LogEvent 
  @message = @msg
, @severity = 0
, @eventSource = '[sprockit].[PrepareBatchRestart]';

UPDATE b
SET ExternalManagerId = @externalManagerId
FROM sprockit.Batch b
WHERE BatchId = @batchId;

-- delete reservations from last attempt
DELETE r
FROM sprockit.Reservation r
  INNER JOIN sprockit.Process p ON p.ProcessId = r.ProcessId
WHERE p.ProcessGroup = @processGroup;

-- clear up after lost executions
-- (this shouldn't happen, but in case a handler crashes without properly releasing a process)
UPDATE e
SET EndDateTime = GETUTCDATE()
  , [EndStatus] = 'Unknown'
FROM sprockit.Execution e
  INNER JOIN sprockit.Batch b ON b.BatchId = e.BatchId
WHERE e.EndDateTime IS NULL
AND b.ProcessGroup = @processGroup;

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
AND ProcessGroup = @processGroup;

-- return batch ID
SELECT @batchId AS BatchId;
