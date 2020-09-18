/*
 * sprockit.[Rewind]
 * Copyright (c) 2018-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Rewind the ETL to restart from a specified process
 */
 
CREATE PROCEDURE [sprockit].[Rewind] (
  @processIdentifier NVARCHAR(1024)
) AS

DECLARE @processId INT
EXEC @processId = [sprockit].[ResolveProcessId] @processIdentifier = @processIdentifier

IF @processId < 0
  RETURN -1  -- error will be thrown from [ResolveProcessId]

UPDATE sprockit.Process
SET [Status] = 'Errored'
WHERE ProcessId = @processId

DECLARE @processGroup INT = (
  SELECT ProcessGroup
  FROM sprockit.Process
  WHERE ProcessId = @processId
)

EXEC sprockit.EnqueueProcesses @processGroup
EXEC sprockit.PrepareBatchRestart @processGroup
