CREATE PROCEDURE sprockit_ReleaseProcess.[test WHEN release fails THEN error rethrown]
AS

-- ARRANGE
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791
DECLARE @endStatus NVARCHAR(20) = 'TestEndStatus'

DECLARE @result TABLE (
  ExecutionId INT
, ProcessType NVARCHAR(10)
, ProcessPath NVARCHAR(850)
, DataWatermark NVARCHAR(255)
)

INSERT INTO @result (
  ExecutionId
, ProcessType
, ProcessPath
, DataWatermark
)
EXEC sprockit.ReserveProcess @handlerId = @handlerId

DECLARE @executionId INT = (
  SELECT ExecutionId
  FROM @result
)

EXEC ('CREATE TRIGGER ForceFailure ON sprockit.Execution AFTER UPDATE AS RAISERROR(''Error!'', 11, 1)')
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '% rethrown by sprockit.usp_RethrowError:% Procedure ForceFailure%'

-- ACT
EXEC sprockit.ReleaseProcess 
  @executionId = @executionId
, @endStatus = @endStatus
