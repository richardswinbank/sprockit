CREATE VIEW sprockit_test_utils.TableColumnAttributes
AS

SELECT
  o.[name] AS TableName
, c.[name] AS ColumnName
, t.[name] AS TypeName
, c.max_length
, c.[precision]
, c.[scale]
, c.is_nullable
, CASE c.is_identity WHEN 1 THEN 1 END AS is_identity
, pkc.index_column_id AS PkOrdinal
, dc.[definition] AS DefaultExpression
, cc.[definition] AS ComputedExpression
, cc.is_persisted
FROM sys.objects o  
  INNER JOIN sys.columns c ON c.[object_id] = o.[object_id]
  INNER JOIN sys.types t ON t.user_type_id = c.user_type_id
  LEFT JOIN sys.computed_columns cc 
    ON cc.[object_id] = c.[object_id]
    AND cc.column_id = c.column_id
  LEFT JOIN sys.default_constraints dc 
    ON dc.parent_object_id = c.[object_id]
    AND dc.parent_column_id = c.column_id
  LEFT JOIN sys.indexes pk 
    ON pk.[object_id] = o.[object_id]
    AND pk.is_primary_key = 1
  LEFT JOIN sys.index_columns pkc
    ON pkc.[object_id] = pk.[object_id]
    AND pkc.index_id = pk.index_id
    AND pkc.column_id = c.column_id
WHERE o.[type] = 'U'
AND OBJECT_SCHEMA_NAME(o.[object_id]) = 'sprockit'