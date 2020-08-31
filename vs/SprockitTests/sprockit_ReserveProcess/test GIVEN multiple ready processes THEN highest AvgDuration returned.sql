CREATE PROCEDURE [sprockit_ReserveProcess].[test GIVEN multiple ready processes THEN highest AvgDuration returned]
AS

-- ARRANGE
DECLARE @batchId INT = 17
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791

EXEC tSQLt.FakeTable @TableName = 'sprockit.Process', @Defaults = 1

INSERT INTO sprockit.Process (
  ProcessId
, ProcessGroup
, AvgDuration
, ProcessType
, ProcessPath
, [Status]
) VALUES
  (31, @processGroup, 10, 'SomeType', '/My/Process/Path', 'Ready')
, (32, @processGroup, 30, 'SomeType', '/My/Other/Process/Path', 'Ready')
, (33, @processGroup, 20, 'OtherType', '[Some].[Different].[Process]', 'Ready')

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
