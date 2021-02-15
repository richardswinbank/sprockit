/*
 * sprockit.[PrepareNewBatch]
 * Copyright (c) 2015-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Prepare a fresh batch run for a specified process group
 */
 
CREATE PROCEDURE [sprockit].[PrepareNewBatch] (
  @processGroup INT
)
AS

-- update scheduling & control metrics
EXEC sprockit.UpdateMetrics @processGroup
EXEC sprockit.SetControlLimits @processGroup

-- set everything not ready
UPDATE p
SET [Status] = 'Not ready'
  , LastStatusUpdate = GETUTCDATE()
  , ErrorCount = 0
FROM sprockit.Process p
WHERE p.ProcessGroup = @processGroup

-- set processes with no predecessors to ready
UPDATE p
SET [Status] = 'Ready'
  , LastStatusUpdate = GETUTCDATE()
  , ErrorCount = 0
FROM sprockit.Process p
  LEFT JOIN sprockit.ProcessDependency pd ON pd.ProcessId = p.ProcessId
WHERE p.ProcessGroup = @processGroup
AND pd.DependsOn IS NULL;

-- set last batch end time
WITH lastBatch AS (
  SELECT TOP 1
    b.BatchId
  , COALESCE(MAX(e.EndDateTime), GETUTCDATE()) AS EndDateTime
  FROM sprockit.Batch b
    LEFT JOIN sprockit.Execution e ON e.BatchId = b.BatchId
  WHERE b.ProcessGroup = @processGroup
  GROUP BY b.BatchId
  ORDER BY b.BatchId DESC
)
UPDATE b
SET EndDateTime = lastBatch.EndDateTime
FROM sprockit.Batch b
  INNER JOIN lastBatch ON lastBatch.BatchId = b.BatchId
WHERE b.EndDateTime IS NULL;

WAITFOR DELAY '00:00:01';  -- enforce batch gap

-- register the new batch
INSERT INTO sprockit.Batch (
  ProcessGroup
) VALUES (
  @processGroup
);
