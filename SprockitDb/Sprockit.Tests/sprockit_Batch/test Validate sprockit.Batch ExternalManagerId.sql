CREATE PROCEDURE [sprockit_Batch].[test Validate sprockit.Batch ExternalManagerId]
AS
 
-- ARRANGE
DECLARE @tableSchema SYSNAME = 'sprockit';
DECLARE @tableName SYSNAME = 'Batch';
DECLARE @columnName SYSNAME = 'ExternalManagerId';

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
, 'nvarchar'
, 2048
, 0
, 0
, 1
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
