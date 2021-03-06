/*
 * sprockit.[SetExecutionProperty]
 * Copyright (c) 2015-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Record a feature of a process's execution
 */

CREATE PROCEDURE [sprockit].[SetExecutionProperty] (
  @executionId INT 
, @propertyValue NVARCHAR(MAX)
, @propertyName NVARCHAR(4000) = NULL
)
AS

IF @executionId IS NULL
  RETURN 1

SET @propertyName = COALESCE(@propertyName, 'SprockitProcessInformation')
SET @propertyValue = COALESCE(@propertyValue, '<null>')
DECLARE @evtSource NVARCHAR(300) = QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID))

IF @propertyName = 'SprockitProcessHandler'
    UPDATE e
    SET ExternalHandlerId = @propertyValue
    FROM sprockit.Execution e
    WHERE e.ExecutionId = @executionId;
ELSE IF @propertyName = 'SprockitProcessWatermark'
BEGIN

    UPDATE p
    SET [CurrentWatermark] = @propertyValue
    FROM sprockit.Execution e
      INNER JOIN sprockit.Process p ON p.ProcessId = e.ProcessId
    WHERE e.ExecutionId = @executionId;

    UPDATE e
    SET UpdatedWatermark = @propertyValue
    FROM sprockit.Execution e
    WHERE e.ExecutionId = @executionId;

END
ELSE IF @propertyName = 'SprockitProcessError'
    EXEC sprockit.LogEvent  
      @message = @propertyValue
    , @executionId = @executionId
    , @severity = 200
    , @eventSource = @evtSource
ELSE IF @propertyName = 'SprockitProcessWarning'
    EXEC sprockit.LogEvent  
      @message = @propertyValue
    , @executionId = @executionId
    , @severity = 100
    , @eventSource = @evtSource
ELSE IF @propertyName = 'SprockitProcessInformation'
    EXEC sprockit.LogEvent  
      @message = @propertyValue
    , @executionId = @executionId
    , @severity = 0
    , @eventSource = @evtSource
ELSE 
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

IF (
    SELECT 
      p.LogPropertyUpdates
    FROM sprockit.Process p
      INNER JOIN sprockit.Execution e ON e.ProcessId = p.ProcessId
    WHERE e.ExecutionId = @executionId
) = 1
BEGIN

    DECLARE @msg NVARCHAR(MAX) = 'Set property "' + @propertyName + '" = ' + @propertyValue

    EXEC sprockit.LogEvent 
      @message = @msg
    , @executionId = @executionId
    , @eventSource = @evtSource

END

RETURN 0
