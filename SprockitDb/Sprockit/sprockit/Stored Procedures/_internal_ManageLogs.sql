/*
 * [sprockit].[_internal_ManageLogs]
 * Copyright (c) 2017-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Manage Sprockit logs.
 */
 
CREATE PROCEDURE sprockit._internal_ManageLogs
AS

DECLARE @cutoff DATETIME = '1900-01-01';
DECLARE @retentionPeriod INT = sprockit.GetProperty('LogRetentionPeriod');
IF @retentionPeriod > 0 AND @retentionPeriod < DATEDIFF(DAY, '1900-01-01', GETUTCDATE())
  SET @cutoff = DATEADD(DAY, -@retentionPeriod, GETUTCDATE());

SELECT 
  @cutoff = COALESCE(MIN([CreatedDateTime]), @cutoff)
FROM sprockit.Batch b
WHERE [CreatedDateTime] >= @cutoff;

DELETE x
FROM sprockit.Execution x
  INNER JOIN sprockit.Batch b ON b.BatchId = x.BatchId
WHERE b.[CreatedDateTime] < @cutoff;

DELETE b
FROM sprockit.Batch b
WHERE b.[CreatedDateTime] < @cutoff;

DELETE e
FROM sprockit.[Event] e
WHERE e.EventDateTime < @cutoff;
