CREATE PROCEDURE sprockit_Process.[test ASSERT ProcessType is foreign key]
AS

--EXPECT
DELETE h
FROM sprockit.ProcessType h
  INNER JOIN sprockit_Process.TestParams tp ON h.ProcessType = tp.ProcessType

EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'The INSERT statement conflicted with the FOREIGN KEY constraint "FK__sprockit_Process__ProcessType".%'

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
