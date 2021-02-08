/*
 * sprockit.[ReserveProcess] 
 * Copyright (c) 2015-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Reserve a process for execution by a handler
 */

CREATE PROCEDURE [sprockit].[ReserveProcess] (
  @batchId INT
)
AS

DECLARE @processGroup INT = (
  SELECT ProcessGroup FROM sprockit.Batch
  WHERE BatchId = @batchId
);

DECLARE @running INT = (
  SELECT COUNT(*) FROM sprockit.Process
  WHERE [Status] = 'Running'
);

DECLARE @enqueueSp NVARCHAR(1024) = sprockit.GetProperty('ProcessSchedulerSpName') + ' @processGroup = @processGroup';
EXEC sp_executesql 
  @statement = @enqueueSp
, @params = N'@processGroup INT'
, @processGroup = @processGroup

DECLARE @processId INT 
DECLARE @isEnabled BIT 
DECLARE @executionId INT

-- loop until we've reserved a process or there's nothing available to reserve
WHILE 1 = 1 
BEGIN

  SET @processId = -1
  SET @isEnabled = 1
  SET @executionId = -1

  -- Choose a process
  SELECT TOP 1 
    @processId = p.ProcessId
  , @isEnabled = p.IsEnabled & pt.HasHandler
  FROM sprockit.Process p WITH (READPAST)
    INNER JOIN sprockit.ProcessType pt ON pt.ProcessType = p.ProcessType
    LEFT JOIN sprockit.Reservation r ON r.ProcessId = p.ProcessId
  WHERE p.[Status] = 'Ready'
  AND p.ProcessGroup = @processGroup
  AND r.ProcessId IS NULL  -- not already reserved
  AND @running < sprockit.GetProperty('MaximumParallelProcesses')  -- below maximum capacity
  ORDER BY
    p.[IsEnabled]        -- disabled processes first (zero execution time; may reveal higher-priority processes downstream)
  , pt.HasHandler        -- processes without handlers first (zero execution time)
  , p.[Priority]         -- highest priority first (low numbers = high priority; priority overrides branch weight)
  , p.BranchWeight DESC  -- then in order of branch weight (heaviest first)
  , p.AvgDuration DESC   -- then in order of average duration (longest first)
  , p.ProcessId          -- ensure determinism (mainly for predictability when testing etc)
  
  -- no ready process? quit
  IF @processId < 0
    BREAK;

  -- reserve the process
  BEGIN TRY  

    INSERT INTO sprockit.Reservation (
      ProcessId
    ) VALUES (
      @processId
    );

  END TRY
  BEGIN CATCH

    IF ERROR_NUMBER() = 2627 AND ERROR_MESSAGE() LIKE '%PRIMARY KEY%' -- PK violation - we've been beaten to it...
      CONTINUE; -- ...so try again for another process.

    -- otherwise rethrow & quit
    EXEC sprockit.RethrowError;
    RETURN -1;

  END CATCH
  
  -- if we've got this far, we've succeeded in reserving the 
  -- process - log the execution and update the process's status
    
  INSERT INTO sprockit.Execution (
    ProcessId
  , BatchId
  , [ProcessType]  
  , [IsEnabled]
  , [Priority]
  , [AvgDuration]
  , [BranchWeight]
  )
  SELECT
    ProcessId
  , @batchId
  , [ProcessType]  
  , [IsEnabled]
  , [Priority]
  , [AvgDuration]
  , [BranchWeight]
  FROM sprockit.Process
  WHERE ProcessId = @processId;

  SET @executionId = SCOPE_IDENTITY();

  UPDATE sprockit.Process
  SET [Status] = 'Running'
    , LastStatusUpdate = GETUTCDATE() 
	, LastExecutionId = @executionId
  WHERE ProcessId = @processId;

  -- if the process is disabled, release it immediately and find another one
  IF @isEnabled = 0
  BEGIN
    EXEC sprockit.ReleaseProcess @executionId, 'Done';
    CONTINUE;
  END
    
  BREAK;

END;

-- return execution details to the process manager
SELECT
  x.ExecutionId AS SprockitExecutionId
, p.ProcessType
, p.ProcessPath
, p.[CurrentWatermark] AS SprockitProcessWatermark
, x.RunningProcesses
FROM (
  SELECT 
    @executionId AS ExecutionId
  , @running AS RunningProcesses
) x
  LEFT JOIN sprockit.Execution e ON e.ExecutionId = x.ExecutionId
  LEFT JOIN sprockit.Process p ON p.ProcessId = e.ProcessId
