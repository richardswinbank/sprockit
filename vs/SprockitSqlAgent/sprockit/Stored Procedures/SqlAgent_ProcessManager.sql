CREATE PROCEDURE sprockit.[SqlAgent_ProcessManager] (
  @processGroup INT = 1
) AS

-- prepare batch restart
DECLARE @batch TABLE (
  BatchId INT
)

INSERT INTO @batch (
  BatchId
)
EXEC sprockit.PrepareBatchRestart

DECLARE @batchId INT = (
  SELECT BatchId FROM @batch
)

-- log process manager start
DECLARE @eventSource NVARCHAR(255) = QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID))
DECLARE @message NVARCHAR(255) = 'Process manager started for batch ID ' 
  + CAST(@batchId AS VARCHAR) + ' (SQL Server session ID ' + CAST(@@SPID AS VARCHAR) + ')'

EXEC sprockit.LogEvent
  @eventSource = @eventSource
, @message = @message

/*
 * start handlers
 */
DECLARE @status TABLE (
  ReadyProcesses INT
, RunningHandlers INT
)

WHILE 1 = 1
BEGIN

  -- enqueue processes
  DELETE FROM @status

  INSERT INTO @status (
    ReadyProcesses
  , RunningHandlers
  )
  EXEC sprockit.EnqueueProcesses 
    @processGroup = @processGroup

  IF (
    SELECT COALESCE(ReadyProcesses + RunningHandlers, 0)
    FROM @status
  ) = 0
    BREAK  -- nothing left to do

  -- start handler if process ready
  IF (
    SELECT COALESCE(ReadyProcesses, 0)
    FROM @status
  ) > 0 AND (
    SELECT COALESCE(RunningHandlers, 0)
    FROM @status
  ) < sprockit.GetProperty('SqlAgent_MaxConcurrentHandlers')
    EXEC sprockit.SqlAgent_StartProcessHandler @batchId = @batchId

  WAITFOR DELAY '00:00:10'

END

-- log process manager end
SET @message = REPLACE(@message, 'Process manager started', 'Process manager stopped')

EXEC sprockit.LogEvent
  @eventSource = @eventSource
, @message = @message
