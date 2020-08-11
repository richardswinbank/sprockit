CREATE PROCEDURE [sprockit].[EnqueueProcesses] (
  @processGroup INT 
)
AS

SET NOCOUNT ON

UPDATE p
SET [Status] = 'Ready'
  , LastStatusUpdate = GETUTCDATE()
FROM sprockit.Process p
WHERE ProcessPath IN (
  SELECT
    ProcessPath
  FROM sprockit.DependencyStatus(@processGroup)
  WHERE ProcessStatus = 'Not ready'
  GROUP BY ProcessPath
  HAVING MIN(PredecessorStatus) = 'Done'  -- has predecessor with status 'Done'
  AND MIN(PredecessorStatus) = MAX(PredecessorStatus)  -- has no predecessor with other status
)

UPDATE succ
SET [Status] = 'Blocked'
FROM sprockit.DependencyStatus(@processGroup) dep
  INNER JOIN sprockit.Process succ ON succ.ProcessPath = dep.ProcessPath
WHERE dep.PredecessorStatus = 'Errored'
AND succ.[Status] <> 'Blocked'

WHILE @@ROWCOUNT > 0
  UPDATE succ
  SET [Status] = 'Blocked'
  FROM sprockit.DependencyStatus(@processGroup) dep
    INNER JOIN sprockit.Process succ ON succ.ProcessPath = dep.ProcessPath
  WHERE dep.PredecessorStatus = 'Blocked'
  AND succ.[Status] <> 'Blocked'

SELECT (
  SELECT COUNT(*)
  FROM sprockit.Process
  WHERE ProcessGroup = @processGroup
  AND [Status] = 'Ready'
) AS ReadyProcesses
, (
  SELECT COUNT(*)
  FROM sprockit.Handler h
    INNER JOIN sprockit.Batch b ON b.BatchId = h.BatchId
  WHERE b.ProcessGroup = @processGroup
  AND h.EndDateTime IS NULL
) AS RunningHandlers