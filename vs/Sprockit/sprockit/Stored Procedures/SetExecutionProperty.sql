/*
 * sprockit.[SetExecutionProperty]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Record a feature of a process's execution
 */

CREATE PROCEDURE [sprockit].[SetExecutionProperty] (
   @executionId INT 
,  @propertyName NVARCHAR(4000)
,  @propertyValue NVARCHAR(MAX)
)
AS

IF @propertyName IS NULL
  RETURN 1

SET @propertyValue = COALESCE(@propertyValue, '<null>')

IF @propertyName = 'SprockitProcessWatermark'
  UPDATE p
  SET DataWatermark = @propertyValue
  FROM sprockit.Execution e
    INNER JOIN sprockit.Process p ON p.ProcessId = e.ProcessId
  WHERE e.ExecutionId = @executionId;

WITH old AS (
  SELECT 
    t.c.value('@name', 'NVARCHAR(4000)') AS [name]
  , t.c.value('@value', 'NVARCHAR(4000)') AS [value]
  FROM [sprockit].[Execution] e
    CROSS APPLY e.ExecutionProperties.nodes('//Properties/Property') t(c)
  WHERE ExecutionId = @executionId
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
WHERE e.ExecutionId = @executionid;

DECLARE @msg NVARCHAR(MAX) = 'Set property "' + @propertyName + '" = ' + @propertyValue
DECLARE @evtSource NVARCHAR(1024) = QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID))

EXEC sprockit.LogEvent 
  @message = @msg
, @executionId = @executionId
, @eventSource = @evtSource
