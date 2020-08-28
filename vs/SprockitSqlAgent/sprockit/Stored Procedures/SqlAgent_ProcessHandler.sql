/*
 * sprockit.[SqlAgent_ProcessHandler]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Handle processes configured in sprockit.Process
 */

CREATE PROCEDURE sprockit.[SqlAgent_ProcessHandler] (
  @handlerId INT 
, @processGroup INT
) AS

DECLARE @execution TABLE (
  ExecutionId INT
, ProcessType NVARCHAR(10)
, ProcessPath NVARCHAR(1024)
);

DECLARE @executionId INT;
DECLARE @processType NVARCHAR(10);
DECLARE @processPath NVARCHAR(1024);
DECLARE @endStatus NVARCHAR(20);
DECLARE @errorMessage NVARCHAR(1024);
DECLARE @errorSource NVARCHAR(20);

WHILE 1 = 1  -- keep handling processes as long as there's work to be done
BEGIN

  -- check that the maximum concurrent handler count hasn't been adjusted down
  -- (and quit if there are too many running now)
  IF (
    SELECT COUNT(*)
    FROM sprockit.Handler
    WHERE EndDateTime IS NULL
  ) > [sprockit].GetProperty('SqlAgent_MaxConcurrentHandlers')
    BREAK;

  -- reserve a process for the handler to run
  DELETE FROM @execution;

  INSERT INTO @execution (
    ExecutionId
  , ProcessType
  , ProcessPath
  )
  EXEC sprockit.ReserveProcess @handlerId = @handlerId;
  
  SET @executionId = -1;
  SELECT @executionId = ExecutionId FROM @execution;

  IF @executionId < 0
  -- nothing ready to run - quit
    BREAK;
      
  BEGIN TRY
    
    -- get process details
    SELECT 
      @processType = ProcessType
    , @processPath = ProcessPath
    FROM @execution;

    -- run the process!
    SET @endStatus = NULL;

    IF @processType = 'SQL'
      EXEC sprockit.SqlAgent_ExecuteProcedure 
        @processPath = @processPath
      , @executionId = @executionId;
    ELSE IF @processType = 'SSIS'
      EXEC sprockit.SqlAgent_ExecuteCatalogPackage
        @processPath = @processPath
      , @executionId = @executionId;

    SET @endStatus = 'Done';

  END TRY
  BEGIN CATCH

    SET @endStatus = 'Errored';
    SET @errorMessage = ERROR_MESSAGE() 
    SET @errorSource = 'Line ' + CAST(ERROR_LINE() AS VARCHAR)

    EXEC sprockit.LogError 
      @executionId = @executionId
    , @message = @errorMessage
    , @errorSource = @errorSource

  END CATCH

  EXEC sprockit.ReleaseProcess 
    @executionId = @executionId
  , @endStatus = @endStatus

  EXEC sprockit.EnqueueProcesses

END

-- report handler completion
EXEC sprockit.UnregisterHandler
  @handlerId = @handlerId
, @endStatus = 'Done'
