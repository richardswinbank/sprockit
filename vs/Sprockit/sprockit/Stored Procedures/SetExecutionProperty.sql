CREATE PROCEDURE [sprockit].[SetExecutionProperty] (
   @executionId INT 
,  @propertyName NVARCHAR(4000)
,  @propertyValue NVARCHAR(MAX)
)
AS

DECLARE @json TABLE (
  [key]	NVARCHAR(4000)
, [value]	NVARCHAR(MAX)
);

INSERT INTO @json (
  [key]
, [value]
)
SELECT 
  oj.[key]
, oj.[value]
FROM sprockit.Execution e
  CROSS APPLY OPENJSON(e.ExecutionProperties) oj
WHERE e.ExecutionId = @executionId;

WITH src AS (
  SELECT 
    @propertyName AS [key]
  , @propertyValue AS [value]
)
MERGE INTO @json tgt
USING src
  ON src.[key] = tgt.[key]
WHEN MATCHED THEN
  UPDATE
  SET [value] = src.[value]
WHEN NOT MATCHED BY TARGET THEN
  INSERT (
    [key]
  , [value]
  ) VALUES (
    src.[key]
  , src.[value]
  )
;

UPDATE e
SET ExecutionProperties = (
  SELECT 
    '{' + STRING_AGG(QUOTENAME([key], '"') + ':' + QUOTENAME([value], '"'), ',') + '}'
  FROM @json
)
FROM sprockit.Execution e
WHERE e.ExecutionId = @executionId;