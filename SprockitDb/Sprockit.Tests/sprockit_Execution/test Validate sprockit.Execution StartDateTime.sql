CREATE PROCEDURE [sprockit_Execution].[test Validate sprockit.Execution StartDateTime]
AS
 
-- ARRANGE
DECLARE @tableSchema SYSNAME = 'sprockit';
DECLARE @tableName SYSNAME = 'Execution';
DECLARE @columnName SYSNAME = 'StartDateTime';
 
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
, [DefaultExpression]
) VALUES (
  @tableSchema
, @tableName
, @columnName
, 'datetime'
, 8
, 23
, 3
, 0
, '(getutcdate())'
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
