CREATE VIEW tsqlt_test_utils.TableColumnAttributes
AS
 
SELECT
  OBJECT_SCHEMA_NAME(o.[object_id]) AS TableSchema
, o.[name] AS TableName
, c.[name] AS ColumnName
, t.[name] AS TypeName
, c.max_length
, c.[precision]
, c.[scale]
, c.is_nullable
, CASE WHEN LOWER(hc.[description]) LIKE '%case-sensitive%' THEN 1 END AS IsCaseSensitive
, CASE c.is_identity WHEN 1 THEN 1 END AS is_identity
, pkc.index_column_id AS PkOrdinal
, dc.[definition] AS DefaultExpression
, cc.[definition] AS ComputedExpression
, cc.is_persisted
FROM sys.objects o  
  INNER JOIN sys.columns c ON c.[object_id] = o.[object_id]
  INNER JOIN sys.types t ON t.user_type_id = c.user_type_id
  LEFT JOIN sys.fn_helpcollations() hc ON hc.[name] = c.collation_name
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
