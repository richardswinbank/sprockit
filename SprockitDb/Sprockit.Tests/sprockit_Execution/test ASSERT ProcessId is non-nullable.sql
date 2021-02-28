CREATE PROCEDURE sprockit_Execution.[test ASSERT ProcessId is non-nullable]
AS

--EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Cannot insert the value NULL into column ''ProcessId''_%'

--ACT
INSERT INTO [sprockit].[Execution] (
  [ProcessId]
, [HandlerId]
, [ExecutionProperties]
, [StartDateTime]
, [EndDateTime]
, [ProcessType]
, [EndStatus]
, [AvgDuration]
, [BranchWeight]
, [IsEnabled]
, [Priority]
) 
SELECT
  NULL
, [HandlerId]
, '<Properties/>'
, GETUTCDATE()
, GETUTCDATE()
, [ProcessType]
, 'Done'
, 0
, 0
, 0
, 0
FROM sprockit_Execution.TestParams
