/*
 * sprockit.[uRewind]
 * Copyright (c) 2018-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Rewind the ETL to restart from a specified process
 */
 
CREATE PROCEDURE [sprockit].[Rewind] (
  @processIdentifier NVARCHAR(1024)
) AS

DECLARE @process TABLE (
  ProcessId INT
)

INSERT INTO @process (
  ProcessId
)
EXEC [sprockit].[ResolveProcessId] @processIdentifier = @processIdentifier

IF @@ROWCOUNT <> 1
  RETURN -1  -- error will be thrown from [ResolveProcessId]

UPDATE sprockit.Process
SET [Status] = 'Errored'
WHERE ProcessId = (
  SELECT ProcessId FROM @process
)

DECLARE @processGroup INT = (
  SELECT ProcessGroup
  FROM sprockit.Process
  WHERE ProcessId = (
    SELECT ProcessId FROM @process
  )
)

EXEC sprockit.EnqueueProcesses @processGroup
EXEC sprockit.PrepareBatchRestart @processGroup