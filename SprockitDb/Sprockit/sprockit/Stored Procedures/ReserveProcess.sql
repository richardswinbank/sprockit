/*
 * sprockit.[ReserveProcess] 
 * Copyright (c) 2015-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Reserve a process for execution by a handler
 */

CREATE PROCEDURE [sprockit].[ReserveProcess] (
  @batchId INT
, @returnSingleRow BIT = 0
)
AS

DECLARE @running INT = (
  SELECT COUNT(*) FROM sprockit.Reservation
);

DECLARE @processId INT 
DECLARE @isEnabled BIT 
DECLARE @executionId INT

-- loop until we've reserved a process or there's nothing available to reserve
WHILE 1 = 1 
BEGIN

  SET @processId = -1
  SET @isEnabled = 1
  SET @executionId = -1

  -- choose a process
  SELECT TOP 1 
    @processId = p.ProcessId
  , @isEnabled = p.IsEnabled & pt.HasHandler
  FROM sprockit.Process p WITH (READPAST)
    INNER JOIN sprockit.Batch b ON b.ProcessGroup = p.ProcessGroup
    INNER JOIN sprockit.ProcessType pt ON pt.ProcessType = p.ProcessType
    LEFT JOIN sprockit.Reservation r ON r.ProcessId = p.ProcessId
  WHERE p.[Status] = 'Ready'
  AND b.BatchId = @batchId
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
  , InitialWatermark
  , [AvgDuration]
  , [BranchWeight]
  , ExecutionParameters
  )
  SELECT
    ProcessId
  , @batchId
  , [ProcessType]  
  , [IsEnabled]
  , [Priority]
  , CurrentWatermark
  , [AvgDuration]
  , [BranchWeight]
  , '<Parameters>' + COALESCE((
      SELECT
        ParameterName AS [Name]
      , ParameterValue AS [Value]
      FROM sprockit.ProcessParameter
      WHERE ProcessId = p.ProcessId
      FOR XML AUTO
    ), '') + '</Parameters>'
  FROM sprockit.Process p
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

/*
 * return execution details to the process manager
 */
-- prepare values to return
WITH cte AS (
  SELECT
    e.ProcessType
  , p.ProcessPath
  , e.InitialWatermark
  , e.ProcessId
  , x.*
  FROM (
    SELECT 
      @executionId AS ExecutionId
    , @running AS RunningProcesses
  ) x
    LEFT JOIN sprockit.Execution e ON e.ExecutionId = x.ExecutionId
    LEFT JOIN sprockit.Process p ON p.ProcessId = e.ProcessId
)
SELECT 
  pp.ParameterName
, pp.ParameterValue
INTO #parameters
FROM sprockit.ProcessParameter pp
  INNER JOIN cte ON cte.ProcessId = pp.ProcessId
  
UNION SELECT 'SprockitProcessType', ProcessType FROM cte
UNION SELECT 'SprockitProcessPath', ProcessPath FROM cte
UNION SELECT 'SprockitProcessWatermark', InitialWatermark FROM cte
UNION SELECT 'SprockitExecutionId', CAST(ExecutionId AS VARCHAR) FROM cte
UNION SELECT 'SprockitRunningProcesses', CAST(RunningProcesses AS VARCHAR) FROM cte
;

IF @returnSingleRow = 0  -- return multi-row result
BEGIN

  SELECT
    ParameterName
  , ParameterValue
  FROM #parameters;

END
ELSE  -- return result as single row
BEGIN

  DECLARE @sql NVARCHAR(MAX) = N'';

  SELECT @sql += '
, ' + COALESCE('''' + REPLACE(ParameterValue, '''', '''''') + '''', 'NULL') + ' AS ' + QUOTENAME(ParameterName)
  FROM #parameters;

  SET @sql = STUFF(@sql, 1,3, 'SELECT');

  EXEC(@sql);

END;