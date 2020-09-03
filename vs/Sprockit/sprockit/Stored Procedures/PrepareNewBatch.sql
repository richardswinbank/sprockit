/*
 * sprockit.[PrepareNewBatch]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Prepare a fresh processing run
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
AND pd.DependsOn IS NULL

INSERT INTO sprockit.Batch (
  ProcessGroup
) VALUES (
  @processGroup
)
