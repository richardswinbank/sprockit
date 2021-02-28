CREATE PROCEDURE sprockit_ReleaseProcess.[test GIVEN valid ExecutionId THEN execution ended]
AS

-- ARRANGE
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

SELECT
  @executionId AS ExecutionId
, @endStatus AS EndStatus
, 1 AS EndDated
INTO #expected

-- ACT
EXEC sprockit.ReleaseProcess 
  @executionId = @executionId
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
