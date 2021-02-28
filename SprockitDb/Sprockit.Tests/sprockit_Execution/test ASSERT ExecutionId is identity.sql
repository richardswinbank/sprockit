CREATE PROCEDURE sprockit_Execution.[test ASSERT ExecutionId is identity]
AS

-- ARRANGE
EXEC tSQLt.FakeTable @TableName = 'sprockit.Execution', @Identity = 1

DECLARE @expected INT = 1

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

DECLARE @actual INT = SCOPE_IDENTITY()

-- ASSERT
EXEC tSQLt.AssertEquals
  @Expected = @expected
, @Actual = @actual