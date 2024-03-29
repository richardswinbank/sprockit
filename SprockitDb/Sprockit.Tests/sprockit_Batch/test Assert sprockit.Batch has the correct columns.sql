CREATE PROCEDURE [sprockit_Batch].[test Assert sprockit.Batch has the correct columns]
AS

-- ARRANGE
SELECT [name]
INTO #expected
FROM sys.columns
WHERE 0 = 1;

INSERT INTO #expected (
  [name]
) VALUES 
  ('BatchId')
, ('EndDateTime')
, ('ExternalManagerId')
, ('ProcessGroup')
, ('CreatedDateTime')

-- ACT
SELECT [name]
INTO #actual
FROM sys.columns
WHERE [object_id] = OBJECT_ID('sprockit.Batch')

-- ASSERT
EXEC tSQLt.AssertEqualsTable @Expected = '#expected', @Actual = '#actual';
