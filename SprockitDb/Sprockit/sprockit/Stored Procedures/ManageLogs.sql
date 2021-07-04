/*
 * [sprockit].[ManageLogs]
 * Copyright (c) 2017-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Manage Sprockit logs.
 */
 
CREATE PROCEDURE sprockit.ManageLogs
AS

DECLARE @cutoff DATETIME = (
  SELECT MIN([CreatedDateTime])
  FROM sprockit.Batch b
  WHERE [CreatedDateTime] > GETUTCDATE() - 90
);

DELETE e
FROM sprockit.Batch b
  INNER JOIN sprockit.Execution e ON e.BatchId = b.BatchId
WHERE b.[CreatedDateTime] < @cutoff;

DELETE b
FROM sprockit.Batch b
WHERE b.[CreatedDateTime] < @cutoff;

DELETE e
FROM sprockit.[Event] e
WHERE e.EventDateTime < @cutoff;
