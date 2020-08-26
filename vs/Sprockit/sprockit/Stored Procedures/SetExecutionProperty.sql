CREATE PROCEDURE [sprockit].[SetExecutionProperty] (
   @executionId INT 
,  @propertyName NVARCHAR(4000)
,  @propertyValue NVARCHAR(MAX)
)
AS

WITH old AS (
  SELECT 
    t.c.value('@name', 'NVARCHAR(4000)') AS [name]
  , t.c.value('@value', 'NVARCHAR(4000)') AS [value]
  FROM [sprockit].[Execution] e
    CROSS APPLY e.ExecutionProperties.nodes('//Properties/Property') t(c)
  WHERE ExecutionId = @executionid
), new AS (
  SELECT
    [name]
  , CASE [name] WHEN @propertyName THEN @propertyValue ELSE [value] END AS [value]
  FROM old
  
  UNION 
  
  SELECT
    @propertyName
  , @propertyValue
)
UPDATE e
SET ExecutionProperties = '<Properties>' + (
  SELECT *
  FROM new AS Property
  FOR XML AUTO
) + '</Properties>'
FROM sprockit.Execution e
WHERE e.ExecutionId = @executionid