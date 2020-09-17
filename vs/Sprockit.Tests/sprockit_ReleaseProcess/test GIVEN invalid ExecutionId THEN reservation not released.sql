CREATE PROCEDURE sprockit_ReleaseProcess.[test GIVEN invalid ExecutionId THEN reservation not released]
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
  HandlerId
, ProcessId
INTO #expected
FROM sprockit.Reservation

-- ACT
EXEC sprockit.ReleaseProcess 
  @executionId = 27
, @endStatus = @endStatus

SELECT
  HandlerId
, ProcessId
INTO #actual
FROM sprockit.Reservation

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
