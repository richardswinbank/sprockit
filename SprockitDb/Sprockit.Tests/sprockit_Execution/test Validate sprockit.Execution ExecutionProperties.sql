CREATE PROCEDURE [sprockit_Execution].[test Validate sprockit.Execution ExecutionProperties]
AS
 
-- ARRANGE
DECLARE @tableSchema SYSNAME = 'sprockit';
DECLARE @tableName SYSNAME = 'Execution';
DECLARE @columnName SYSNAME = 'ExecutionProperties';
 
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
, 'xml'
, -1
, 0
, 0
, 0
, '(''<Properties/>'')'
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
