CREATE PROCEDURE sprockit_Execution.[test ASSERT ExecutionProperties has schema]
AS

--EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'XML Validation: Declaration not found for element ''MyUndefinedXmlElement''. %'

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
, '<MyUndefinedXmlElement/>'
, GETUTCDATE()
, GETUTCDATE()
, [ProcessType]
, 'Done'
, 0
, 0
, 0
, 0
FROM sprockit_Execution.TestParams
