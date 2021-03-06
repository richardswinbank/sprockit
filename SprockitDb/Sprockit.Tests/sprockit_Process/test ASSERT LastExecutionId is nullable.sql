﻿CREATE PROCEDURE sprockit_Process.[test ASSERT LastExecutionId is nullable]
AS

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
, NULL
, '20200101000000'
, '20200917204254'
, 467
, 794
, 1
, 90
FROM sprockit_Process.TestParams

-- ASSERT
-- (no error)

