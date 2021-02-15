/*
 * sprockit.[ReleaseProcess] 
 * Copyright (c) 2015-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Release a process after execution by a handler
 */

CREATE PROCEDURE [sprockit].[ReleaseProcess] (
  @executionId INT
, @endStatus NVARCHAR(20) = 'Done'
, @metricName NVARCHAR(128) = NULL
, @metricValue DECIMAL(19,5) = NULL
)
AS

BEGIN TRY  -- ensure that process status doesn't change if earlier updates fail

  -- complete execution record
  UPDATE e
  SET EndStatus = @endStatus
    , EndDateTime = GETUTCDATE()
  FROM sprockit.Execution e
  WHERE e.ExecutionId = @executionId;

  -- release reservation
  DELETE r
  FROM sprockit.Execution e
    INNER JOIN sprockit.Reservation r ON r.ProcessId = e.ProcessId
  WHERE e.ExecutionId = @executionId;

  -- update process status
  UPDATE p
  SET [Status] = @endStatus
    , LastStatusUpdate = GETUTCDATE()
    , ErrorCount = CASE @endStatus WHEN 'Errored' THEN ErrorCount + 1 ELSE 0 END
  FROM sprockit.Execution e
    INNER JOIN sprockit.Process p ON p.ProcessId = e.ProcessId
  WHERE e.ExecutionId = @executionId;

END TRY
BEGIN CATCH
  
  EXEC sprockit.RethrowError;
  RETURN -1;

END CATCH

/*
 * call process scheduler (change to process status may mean other processes are now ready
 */
-- get process group
DECLARE @processGroup INT = (
  SELECT p.ProcessGroup
  FROM sprockit.Execution e
    INNER JOIN sprockit.Process p ON p.ProcessId = e.ProcessId
  WHERE e.ExecutionId = @executionId
)

-- table to suppress output
DECLARE @output TABLE (
  ReadyProcesses INT
, RunningHandlers INT
)

-- call scheduler
INSERT INTO @output (
  ReadyProcesses
, RunningHandlers
)
EXEC sprockit.EnqueueProcesses @processGroup = @processGroup
