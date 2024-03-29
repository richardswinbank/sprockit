CREATE PROCEDURE [sprockit_Execution].[test Assert sprockit.Execution has the correct columns]
AS
 
-- ARRANGE
SELECT [name]
INTO #expected
FROM sys.columns
WHERE 0 = 1;
 
INSERT INTO #expected (
  [name]
) VALUES 
  ('ExecutionId')
, ('ProcessId')
, ('BatchId')
, ('ExternalHandlerId')
, ('ExecutionParameters')
, ('ExecutionProperties')
, ('StartDateTime')
, ('EndDateTime')
, ('ProcessType')
, ('EndStatus')
, ('AvgDuration')
, ('InitialWatermark')
, ('UpdatedWatermark')
, ('BranchWeight')
, ('IsEnabled')
, ('Priority');
 
-- ACT
SELECT [name]
INTO #actual
FROM sys.columns
WHERE [object_id] = OBJECT_ID('[sprockit].[Execution]')
 
-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual';
