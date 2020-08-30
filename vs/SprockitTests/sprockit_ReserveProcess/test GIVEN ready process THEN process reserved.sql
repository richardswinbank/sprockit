CREATE PROCEDURE sprockit_ReserveProcess.[test GIVEN ready process THEN process reserved]
AS

-- ARRANGE
DECLARE @batchId INT = 17
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791

EXEC tSQLt.FakeTable 'sprockit.Process'

INSERT INTO sprockit.Process (
  ProcessId
, ProcessGroup
, ProcessType
, ProcessPath
, [Status]
) VALUES
  (31, @processGroup, 'SomeType', '/My/Process/Path', 'Not ready')
, (32, @processGroup, 'SomeType', '/My/Other/Process/Path', 'Ready')
, (33, @processGroup, 'OtherType', '[Some].[Different].[Process]', 'Not ready')

EXEC tSQLt.FakeTable 'sprockit.Reservation'

SELECT
  ProcessId
, HandlerId
INTO #expected
FROM sprockit.Reservation
WHERE 0 = 1

INSERT INTO #expected (
  ProcessId
, HandlerId
) VALUES (
  32
, @handlerId
)

-- ACT
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

SELECT
  ProcessId
, HandlerId
INTO #actual
FROM sprockit.Reservation

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
