CREATE PROCEDURE sprockit_ReserveProcess.[test GIVEN ready process THEN process returned]
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

CREATE TABLE #actual (
  ExecutionId INT
, ProcessType NVARCHAR(10)
, ProcessPath NVARCHAR(850)
)

SELECT *
INTO #expected
FROM #actual

INSERT INTO #expected (
  ExecutionId
, ProcessType
, ProcessPath
) VALUES (
  1
, 'SomeType'
, '/My/Other/Process/Path'
)

-- ACT
INSERT INTO #actual (
  ExecutionId
, ProcessType
, ProcessPath
)
EXEC sprockit.ReserveProcess @handlerId = @handlerId

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#Actual'
