CREATE PROCEDURE [sprockit_Property].[test Assert sprockit.Property has the correct columns]
AS
 
-- ARRANGE
SELECT [name]
INTO #expected
FROM sys.columns
WHERE 0 = 1;
 
INSERT INTO #expected (
  [name]
) VALUES 
  ('PropertyName')
, ('PropertyValue')
, ('DataType')
, ('Description');
 
-- ACT
SELECT [name]
INTO #actual
FROM sys.columns
WHERE [object_id] = OBJECT_ID('[sprockit].[Property]')
 
-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual';
