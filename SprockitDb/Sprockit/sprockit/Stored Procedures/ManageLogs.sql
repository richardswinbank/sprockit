/*
 * [sprockit].[ManageLogs]
 * Copyright (c) 2017-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Manage Sprockit logs.
 */
 
CREATE PROCEDURE sprockit.ManageLogs
AS

DELETE pcl
FROM sprockit.ProcessControlLimits pcl
  LEFT JOIN sprockit.Process p ON p.ProcessId = pcl.ProcessId
WHERE p.ProcessId IS NULL;

DECLARE @cutoff DATETIME = (
  SELECT MIN(StartDateTime)
  FROM sprockit.Batch b
  WHERE StartDateTime > GETUTCDATE() - 90
);

DELETE pm
FROM sprockit.Batch b
  INNER JOIN sprockit.Execution e ON e.BatchId = b.BatchId
  INNER JOIN sprockit.ProcessMetric pm ON pm.ExecutionId = e.ExecutionId
WHERE b.StartDateTime < @cutoff;

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
