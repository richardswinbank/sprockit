CREATE PROCEDURE sprockit_SetExecutionProperty.setup
AS

EXEC tSQLt.FakeTable 'sprockit.Process'

INSERT INTO sprockit.Process (
  ProcessId
, [CurrentWatermark]
) VALUES
  (31, 'OldValue')
, (32, 'OldValue')
, (33, 'OldValue')
, (34, 'OldValue')

EXEC tSQLt.FakeTable 'sprockit.Execution'

INSERT INTO sprockit.Execution (
  ExecutionId
, ProcessId
, ExecutionProperties
) VALUES 
  (431, 31, '<Properties><Property name="MyFirstProperty" value="value1" /></Properties>')
, (432, 32, '<Properties></Properties>')
, (433, 33, '<Properties><Property name="MySecondProperty" value="value2" /><Property name="MyThirdProperty" value="value3" /></Properties>')
, (434, 34, '<Properties><Property name="MyFourthProperty" value="value4" /></Properties>')
