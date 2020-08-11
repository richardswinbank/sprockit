CREATE PROCEDURE [sprockit].[ReleaseReservation] (
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
  FROM sprockit.Execution e
    INNER JOIN sprockit.Process p ON p.ProcessId = e.ProcessId
  WHERE e.ExecutionId = @executionId

END TRY
BEGIN CATCH
  
  THROW;

END CATCH