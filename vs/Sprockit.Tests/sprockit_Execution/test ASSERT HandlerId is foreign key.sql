CREATE PROCEDURE sprockit_Execution.[test ASSERT HandlerId is foreign key]
AS

--EXPECT
DELETE h
FROM sprockit.Handler h
  INNER JOIN sprockit_Execution.TestParams tp ON h.HandlerId = tp.HandlerId

EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'The INSERT statement conflicted with the FOREIGN KEY constraint "FK__sprockit_Execution__HandlerId".%'

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
  [ProcessId]
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
