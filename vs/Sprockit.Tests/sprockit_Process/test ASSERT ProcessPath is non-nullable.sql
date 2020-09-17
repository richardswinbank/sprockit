﻿CREATE PROCEDURE sprockit_Process.[test ASSERT ProcessPath is non-nullable]
AS

--EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Cannot insert the value NULL into column ''ProcessPath''_%'

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
, NULL
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
