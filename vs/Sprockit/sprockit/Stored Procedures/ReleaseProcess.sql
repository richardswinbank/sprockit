﻿/*
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

IF @endStatus = 'Done' AND @metricName IS NOT NULL
BEGIN

  IF @metricName = 'ProcessDuration'
    SELECT 
      @metricValue = DATEDIFF(SECOND, StartDateTime, EndDateTime)
    FROM sprockit.Execution
    WHERE ExecutionId = @executionId;

  EXEC sprockit.LogProcessMetric
    @executionId = @executionId
  , @metricName = @metricName
  , @metricValue = @metricValue;

END