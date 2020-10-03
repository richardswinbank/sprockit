CREATE PROCEDURE sprockit_Process.[test ASSERT LastStatusUpdate has default]
AS

--ARRANGE
DECLARE @beforeTest DATETIME = GETUTCDATE()

--ACT
INSERT INTO [sprockit].[Process] (
  [ProcessGroup]
, [ProcessPath]
, [ProcessType]
, [IsValidator]
, [Status]
, [ErrorCount]
--, [LastStatusUpdate]
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
--, GETUTCDATE()
, 75
, '20200101000000'
, '20200917204254'
, 467
, 794
, 1
, 90
FROM sprockit_Process.TestParams

DECLARE @lastStatusUpdate DATETIME = (
  SELECT LastStatusUpdate FROM sprockit.Process
  WHERE ProcessId = SCOPE_IDENTITY()
)

-- ASSERT
DECLARE @afterTest DATETIME = GETUTCDATE()

IF COALESCE(@lastStatusUpdate, '1900-01-01') < @beforeTest OR COALESCE(@lastStatusUpdate, '9000-01-01') > @afterTest
  EXEC tSQLt.Fail '[LastStatusUpdate] out of range'
