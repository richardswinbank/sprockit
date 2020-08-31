CREATE PROCEDURE sprockit_ReleaseProcess.[test GIVEN invalid ExecutionId THEN error count unchanged]
AS

-- ARRANGE
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
, ErrorCount
INTO #expected
FROM sprockit.Process

-- ACT
EXEC sprockit.ReleaseProcess 
  @executionId = 27
, @endStatus = @endStatus

SELECT
  ProcessId
, ErrorCount
INTO #actual
FROM sprockit.Process

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
