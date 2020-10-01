CREATE PROCEDURE sprockit_Process.[test ASSERT ProcessId is identity]
AS

-- ARRANGE
EXEC tSQLt.FakeTable @TableName = 'sprockit.Process', @Identity = 1

DECLARE @expected INT = 1

--ACT
INSERT INTO [sprockit].[Process] (
  [ProcessGroup]
, [ProcessPath]
, [ProcessType]
, [IsValidator]
, [Status]
, [ErrorCount]
, [LastStatusUpdate]
, [LastExecutionId]
, [CurrentWatermark]
, [AvgDuration]
, [BranchWeight]
, [IsEnabled]
, [Priority]
)
SELECT 
  [ProcessGroup]
, '[My].[Process].[Path]'
, [ProcessType]
, 0
, 'Done'
, 0
, GETUTCDATE()
, 75
, '20200917204254'
, 467
, 794
, 1
, 90
FROM sprockit_Process.TestParams

DECLARE @actual INT = SCOPE_IDENTITY()

-- ASSERT
EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual