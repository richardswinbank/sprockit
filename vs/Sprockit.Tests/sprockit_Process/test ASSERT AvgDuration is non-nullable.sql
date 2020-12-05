CREATE PROCEDURE sprockit_Process.[test ASSERT AvgDuration is non-nullable]
AS

--EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Cannot insert the value NULL into column ''AvgDuration''_%'

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
, NULL
, 794
, 1
, 90
FROM sprockit_Process.TestParams
