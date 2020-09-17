CREATE PROCEDURE sprockit_Process.[test ASSERT BranchWeight is non-nullable]
AS

--EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Cannot insert the value NULL into column ''BranchWeight''_%'

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
, [DataWatermark]
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
, NULL
, 1
, 90
FROM sprockit_Process.TestParams
