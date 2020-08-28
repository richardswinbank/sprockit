/*
 * sprockit.[ReleaseProcess] 
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Release a process after execution by a handler
 */

CREATE PROCEDURE [sprockit].[ReleaseProcess] (
  @executionId INT
, @endStatus NVARCHAR(20) = 'Done'
)
AS

BEGIN TRY

  UPDATE e
  SET EndStatus = @endStatus
    , EndDateTime = GETUTCDATE()
  FROM sprockit.Execution e
  WHERE e.ExecutionId = @executionId

  DELETE r
  FROM sprockit.Execution e
    INNER JOIN sprockit.Reservation r ON r.ProcessId = e.ProcessId
  WHERE e.ExecutionId = @executionId

  UPDATE p
  SET [Status] = @endStatus
    , LastStatusUpdate = GETUTCDATE()
	, ErrorCount += CASE @endStatus WHEN 'Errored' THEN 1 ELSE 0 END
  FROM sprockit.Execution e
    INNER JOIN sprockit.Process p ON p.ProcessId = e.ProcessId
  WHERE e.ExecutionId = @executionId

END TRY
BEGIN CATCH
  
  EXEC sprockit.RethrowError
  RETURN -1

END CATCH