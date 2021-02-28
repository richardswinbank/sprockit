CREATE PROCEDURE sprockit_Execution.[test ASSERT StartDateTime has default]
AS

--ARRANGE
DECLARE @beforeTest DATETIME = GETUTCDATE()

--ACT
INSERT INTO [sprockit].[Execution] (
  [ProcessId]
, [HandlerId]
, [ExecutionProperties]
--, [StartDateTime]
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
, [ProcessType]
, 'Done'
, 0
, 0
, 0
, 0
FROM sprockit_Execution.TestParams

DECLARE @startDateTime DATETIME = (
  SELECT StartDateTime FROM sprockit.Execution
  WHERE ExecutionId = SCOPE_IDENTITY()
)

-- ASSERT
DECLARE @afterTest DATETIME = GETUTCDATE()

IF COALESCE(@startDateTime, '1900-01-01') < @beforeTest OR COALESCE(@startDateTime, '9000-01-01') > @afterTest
  EXEC tSQLt.Fail '[StartDateTime] out of range'
