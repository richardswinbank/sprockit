CREATE PROCEDURE [sprockit_Event].[test Assert sprockit.Event has the correct columns]
AS
 
-- ARRANGE
SELECT [name]
INTO #expected
FROM sys.columns
WHERE 0 = 1;
 
INSERT INTO #expected (
  [name]
) VALUES 
  ('EventId')
, ('EventDateTime')
, ('Severity')
, ('ExecutionId')
, ('EventSource')
, ('Message')
, ('MetricValue');
 
-- ACT
SELECT [name]
INTO #actual
FROM sys.columns
WHERE [object_id] = OBJECT_ID('[sprockit].[Event]')
 
-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual';
