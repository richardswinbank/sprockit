CREATE PROCEDURE sprockit_Process.[test ASSERT ProcessPath is unique]
AS

--ARRANGE
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
, '20200101000000'
, '20200917204254'
, 467
, 794
, 1
, 90
FROM sprockit_Process.TestParams

--EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Violation of UNIQUE KEY constraint ''UQ__sprockit_Process__ProcessPath''.%'

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
