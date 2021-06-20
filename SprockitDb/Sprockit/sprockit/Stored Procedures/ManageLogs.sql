/*
 * [sprockit].[ManageLogs]
 * Copyright (c) 2017-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Manage Sprockit logs.
 */
 
CREATE PROCEDURE sprockit.ManageLogs
AS

DECLARE @cutoff DATETIME = 
  CASE sprockit.GetProperty('LogRetentionPeriod')
    WHEN 0 THEN '1900-01-01'
    ELSE DATEADD(DAY, -sprockit.GetProperty('LogRetentionPeriod'), GETUTCDATE())
  END;

DELETE e
FROM sprockit.Batch b
  INNER JOIN sprockit.Execution e ON e.BatchId = b.BatchId
WHERE b.StartDateTime < @cutoff;

DELETE b
FROM sprockit.Batch b
WHERE b.StartDateTime < @cutoff;

DELETE e
FROM sprockit.[Event] e
WHERE e.EventDateTime < @cutoff;
