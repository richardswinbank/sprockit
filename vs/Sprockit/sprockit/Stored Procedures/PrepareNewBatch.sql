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

-- update scheduling metrics
EXEC sprockit.UpdateMetrics @processGroup

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
  SELECT 
    BatchId
  , COALESCE(MAX(COALESCE(EndDateTime, GETUTCDATE())), GETUTCDATE()) AS EndDateTime
  FROM sprockit.Execution
  WHERE BatchId = (
    SELECT TOP 1 BatchId
    FROM sprockit.Batch
    WHERE ProcessGroup = @processGroup
    ORDER BY StartDateTime DESC
  )
  GROUP BY BatchId
)
UPDATE b
SET EndDateTime = lastBatch.EndDateTime
FROM sprockit.Batch b
  INNER JOIN lastBatch ON lastBatch.BatchId = b.BatchId
WHERE b.EndDateTime IS NULL;

-- register the new batch
INSERT INTO sprockit.Batch (
  ProcessGroup
) VALUES (
  @processGroup
);
