/*
 * sprockit.[Rewind]
 * Copyright (c) 2018-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Rewind the ETL to restart from a specified process
 */
 
CREATE PROCEDURE [sprockit].[Rewind] (
  @processIdentifier NVARCHAR(1024)
) AS

DECLARE @processId INT;
EXEC @processId = [sprockit].[ResolveProcessId] @processIdentifier = @processIdentifier;

IF @processId < 0
  RETURN -1;  -- error will be thrown from [ResolveProcessId]

WITH cte AS (
  SELECT ProcessId 
  FROM sprockit.DependencyStatus(1)
  WHERE ProcessId = @processId

  UNION ALL

  SELECT ds.ProcessId
  FROM sprockit.DependencyStatus(1) ds
    INNER JOIN cte ON cte.ProcessId = ds.PredecessorId
)
UPDATE p
SET p.[Status] = 
  CASE p.ProcessId
    WHEN @processId THEN 'Ready'
    ELSE 'Not ready'
  END
FROM sprockit.Process p 
  INNER JOIN cte ON p.ProcessId = cte.ProcessId
;
