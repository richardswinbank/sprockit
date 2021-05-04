/*
 * sprockit.[EnqueueProcesses]
 * Copyright (c) 2015-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Update process readiness based on dependency information
 */
 
CREATE PROCEDURE [sprockit].[EnqueueProcesses] (
  @processGroup INT 
)
AS

SET NOCOUNT ON;

-- Set 'Not ready' processes to 'Ready' when predecessors are all 'Done'
UPDATE p
SET [Status] = 'Ready'
  , LastStatusUpdate = GETUTCDATE()
FROM sprockit.Process p
WHERE ProcessPath IN (
  SELECT
    ProcessPath
  FROM sprockit.DependencyStatus(@processGroup)
  WHERE ProcessStatus IN ('Not ready', 'Blocked')
  GROUP BY ProcessPath
  HAVING MIN(PredecessorStatus) = 'Done'  -- has predecessor with status 'Done'
  AND MIN(PredecessorStatus) = MAX(PredecessorStatus)  -- has no predecessor with other status
);
  
-- Set 'Errored' processes to 'Ready' when error is retryable and under retry limit
UPDATE p
SET [Status] = 'Ready'
  , LastStatusUpdate = GETUTCDATE()
FROM sprockit.Process p
  INNER JOIN sprockit.[Event] e ON e.ExecutionId = p.LastExecutionId
  INNER JOIN sprockit.RetryableError re 
    ON p.ProcessType LIKE re.ProcessType
    AND p.ProcessPath LIKE re.ProcessPathPattern
    AND e.EventSource LIKE re.EventSourcePattern
    AND e.[Message] LIKE re.MessagePattern
WHERE p.[Status] = 'Errored' 
AND e.Severity >= 200
AND p.ErrorCount <= re.MaximumRetries;

-- Set successors of 'Errored' processes to 'Blocked'
UPDATE succ
SET [Status] = 'Blocked'
  , LastStatusUpdate = GETUTCDATE()
FROM sprockit.DependencyStatus(@processGroup) dep
  INNER JOIN sprockit.Process succ ON succ.ProcessPath = dep.ProcessPath
WHERE dep.PredecessorStatus = 'Errored'
AND succ.[Status] <> 'Blocked';

-- Set successors of 'Blocked' processes to 'Blocked'
WHILE @@ROWCOUNT > 0
  UPDATE succ
  SET [Status] = 'Blocked'
    , LastStatusUpdate = GETUTCDATE()
  FROM sprockit.DependencyStatus(@processGroup) dep
    INNER JOIN sprockit.Process succ ON succ.ProcessPath = dep.ProcessPath
  WHERE dep.PredecessorStatus = 'Blocked'
  AND succ.[Status] <> 'Blocked';

-- set formerly 'Blocked' processes to 'Not ready'
-- (in case errored processes are requeued manually in-flight)
DECLARE @rows INT = 1;

WHILE @rows > 0
BEGIN

  WITH unblocked AS (
    SELECT 
      p.ProcessId
    FROM sprockit.ProcessDependency pd
      INNER JOIN sprockit.Process d ON d.ProcessId = pd.DependsOn
      INNER JOIN sprockit.Process p ON p.ProcessId = pd.ProcessId
    WHERE p.[Status] = 'Blocked'
    GROUP BY p.ProcessId
    HAVING MAX(CASE WHEN d.[Status] IN ('Errored', 'Blocked') THEN 1 ELSE 0 END) = 0 
  )
  UPDATE p
  SET p.[Status] = 'Not ready'
    , p.LastStatusUpdate = GETUTCDATE()
  FROM sprockit.Process p
    INNER JOIN unblocked ub ON ub.ProcessId = p.ProcessId;

  SET @rows = @@ROWCOUNT;

END
