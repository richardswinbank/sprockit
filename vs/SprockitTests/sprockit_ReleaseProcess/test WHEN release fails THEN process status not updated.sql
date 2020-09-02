CREATE PROCEDURE sprockit_ReleaseProcess.[test WHEN release fails THEN process status not updated]
AS

-- ARRANGE
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791
DECLARE @endStatus NVARCHAR(20) = 'TestEndStatus'

DECLARE @result TABLE (
  ExecutionId INT
, ProcessType NVARCHAR(10)
, ProcessPath NVARCHAR(850)
)

INSERT INTO @result (
  ExecutionId
, ProcessType
, ProcessPath
)
EXEC sprockit.ReserveProcess @handlerId = @handlerId

DECLARE @executionId INT = (
  SELECT ExecutionId
  FROM @result
)

SELECT
  ProcessId
, CASE ProcessId WHEN 32 THEN 'Running' ELSE [Status] END AS [Status]
INTO #expected
FROM sprockit.Process

EXEC ('CREATE TRIGGER ForceFailure ON sprockit.Execution AFTER UPDATE AS RAISERROR(''Error!'', 11, 1)')
EXEC tSQLt.ExpectException  -- swallow rethrown error

-- ACT
EXEC sprockit.ReleaseProcess 
  @executionId = @executionId
, @endStatus = @endStatus

SELECT
  ProcessId
, [Status]
INTO #actual
FROM sprockit.Process

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
