CREATE PROCEDURE [sprockit_Batch].[test Validate sprockit.Batch ProcessGroup]
AS
 
-- ARRANGE
DECLARE @tableSchema SYSNAME = 'sprockit';
DECLARE @tableName SYSNAME = 'Batch';
DECLARE @columnName SYSNAME = 'ProcessGroup';

SELECT *
INTO #expected
FROM tsqlt_test_utils.TableColumnAttributes
WHERE 0 = 1;

INSERT INTO #expected (
  [TableSchema]
, [TableName]
, [ColumnName]
, [TypeName]
, [max_length]
, [precision]
, [scale]
, [is_nullable]
) VALUES (
  @tableSchema
, @tableName
, @columnName
, 'int'
, 4
, 10
, 0
, 0
);

-- ACT
SELECT *
INTO #actual
FROM tsqlt_test_utils.TableColumnAttributes
WHERE TableName = @tableName
AND ColumnName = @columnName;

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual';
