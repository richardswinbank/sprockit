CREATE PROCEDURE sprockit_Process.[test ASSERT AvgDuration has default]
AS

--ARRANGE
DECLARE @expected INT = 0

--ACT
INSERT INTO [sprockit].[Process] (
  [ProcessGroup]
, [ProcessPath]
, [ProcessType]
, [LogPropertyUpdates]
, [Status]
, [ErrorCount]
, [LastStatusUpdate]
, [LastExecutionId]
, [DefaultWatermark]
, [CurrentWatermark]
--, [AvgDuration]
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
, '20200101000000'
, '20200917204254'
--, 467
, 794
, 1
, 90
FROM sprockit_Process.TestParams

DECLARE @processId INT = SCOPE_IDENTITY()

--ASSERT
DECLARE @actual INT = (
  SELECT AvgDuration FROM sprockit.Process
  WHERE ProcessId = @processId
)

EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual
