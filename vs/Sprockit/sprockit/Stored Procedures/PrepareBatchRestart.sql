CREATE PROCEDURE [sprockit].[PrepareBatchRestart] (
  @processGroup INT
)
AS

-- reset process statuses
UPDATE sprockit.Process
SET [Status] = 
  CASE [Status]
    WHEN 'Blocked' THEN 'Not ready'
    ELSE 'Ready'
  END
, LastStatusUpdate = GETUTCDATE()
WHERE [Status] IN (
  'Starting'
, 'Running'
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