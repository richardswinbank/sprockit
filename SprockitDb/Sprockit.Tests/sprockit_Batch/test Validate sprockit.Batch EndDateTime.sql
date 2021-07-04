CREATE PROCEDURE [sprockit_Batch].[test Validate sprockit.Batch EndDateTime]
AS

-- ARRANGE
DECLARE @tableName SYSNAME = 'Batch';
DECLARE @columnName SYSNAME = 'EndDateTime';

SELECT *
INTO #expected
FROM sprockit_test_utils.TableColumnAttributes
WHERE 0 = 1;

INSERT INTO #expected (
  [TableName]
, [ColumnName]
, [TypeName]
, [max_length]
, [precision]
, [scale]
, [is_nullable]
) VALUES (
  @tableName
, @columnName
, 'datetime'
, 8
, 23
, 3
, 1
);

-- ACT
SELECT *
INTO #actual
FROM sprockit_test_utils.TableColumnAttributes
WHERE TableName = @tableName
AND ColumnName = @columnName;

-- ASSERT
EXEC tSQLt.AssertEqualsTable @Expected = '#expected', @Actual = '#actual';
