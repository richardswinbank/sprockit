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
  SELECT 
    ProcessId 
  , ProcessGroup
  FROM sprockit.Process
  WHERE ProcessId = @processId

  UNION ALL

  SELECT 
    ds.ProcessId
  , cte.ProcessGroup
  FROM cte
    CROSS APPLY sprockit.DependencyStatus(cte.ProcessGroup) ds
  WHERE cte.ProcessId = ds.PredecessorId
)
UPDATE p
SET p.[Status] = 
    CASE p.ProcessId
      WHEN @processId THEN 'Ready'
      ELSE 'Not ready'
    END
  , p.ErrorCount = 0
FROM sprockit.Process p 
  INNER JOIN cte ON p.ProcessId = cte.ProcessId
;
