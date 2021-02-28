CREATE PROCEDURE sprockit_ReleaseProcess.[test WHEN release succeeds THEN enqueue called]
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

EXEC tSQLt.SpyProcedure 'sprockit.EnqueueProcesses'

SELECT
  @processGroup AS processGroup
INTO #expected

-- ACT
EXEC sprockit.ReleaseProcess 
  @executionId = @executionId
, @endStatus = @endStatus

SELECT
  processGroup
INTO #actual
FROM sprockit.EnqueueProcesses_SpyProcedureLog

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
