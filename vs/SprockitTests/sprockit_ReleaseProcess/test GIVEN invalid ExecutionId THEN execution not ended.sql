CREATE PROCEDURE sprockit_ReleaseProcess.[test GIVEN invalid ExecutionId THEN execution not ended]
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
  @executionId AS ExecutionId
, CAST(NULL AS NVARCHAR(20)) AS EndStatus
, 0 AS EndDated
INTO #expected

-- ACT
EXEC sprockit.ReleaseProcess 
  @executionId = 27
, @endStatus = @endStatus

SELECT
  ExecutionId
, EndStatus
, CASE WHEN EndDateTime IS NOT NULL THEN 1 ELSE 0 END AS EndDated
INTO #actual
FROM sprockit.Execution

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
