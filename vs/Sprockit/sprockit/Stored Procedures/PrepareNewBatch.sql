CREATE PROCEDURE [sprockit].[PrepareNewBatch] (
  @processGroup INT
)
AS

-- update scheduling metrics
EXEC sprockit.UpdateMetrics @processGroup

-- delete reservations from last batch
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

-- set everything not ready
UPDATE p
SET [Status] = 'Not ready'
  , LastStatusUpdate = GETUTCDATE()
FROM sprockit.Process p
WHERE p.ProcessGroup = @processGroup

-- set processes with no predecessors to ready
UPDATE p
SET [Status] = 'Ready'
  , LastStatusUpdate = GETUTCDATE()
FROM sprockit.Process p
  LEFT JOIN sprockit.ProcessDependency pd ON pd.ProcessPath = p.ProcessPath
WHERE p.ProcessGroup = @processGroup
AND pd.DependsOn IS NULL

INSERT INTO sprockit.Batch (
  ProcessGroup
) VALUES (
  @processGroup
)