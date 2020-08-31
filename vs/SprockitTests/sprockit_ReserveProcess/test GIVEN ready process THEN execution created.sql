CREATE PROCEDURE [sprockit_ReserveProcess].[test GIVEN ready process THEN execution created]
AS

-- ARRANGE
DECLARE @batchId INT = 17
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791

EXEC tSQLt.FakeTable @TableName = 'sprockit.Process', @Defaults = 1

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

SELECT
  ProcessId
, @handlerId AS HandlerId
, [ProcessType]  
, [IsEnabled]
, [Priority]
, [AvgDuration]
, [BranchWeight]
INTO #expected
FROM sprockit.Process
WHERE ProcessId = 32

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
, [ProcessType]  
, [IsEnabled]
, [Priority]
, [AvgDuration]
, [BranchWeight]
INTO #actual
FROM sprockit.Execution

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#Actual'
