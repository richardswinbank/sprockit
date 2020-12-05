/*
 * sprockit.[SqlAgent_ExecuteCatalogPackage]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Execute a specified package from the SSIS catalog
 */
 
CREATE PROCEDURE sprockit.SqlAgent_ExecuteCatalogPackage (
  @processPath NVARCHAR(1024)
, @executionId INT
) AS

-- get package details
DECLARE @folderName NVARCHAR(128)
DECLARE @projectName NVARCHAR(128)
DECLARE @packageName NVARCHAR(260)

SELECT
  @folderName = CASE [index] WHEN 1 THEN [value] END
, @projectName = CASE [index] WHEN 2 THEN [value] END
, @packageName = CASE [index] WHEN 3 THEN [value] END
FROM sprockit.[string_split](@processPath, '/')

/*
 * run the package
 */
-- is this a 32 or 64 bit install?
DECLARE @is32bit BIT =
  CASE RIGHT(SUBSTRING(@@VERSION, CHARINDEX('<', @@VERSION), 4), 2)
    WHEN '64' THEN 0
    ELSE 1
  END

-- create the execution
DECLARE @ssisExecutionId BIGINT

EXEC [SSISDB].[catalog].[create_execution] 
  @package_name = @packageName
, @project_name = @projectName
, @folder_name = @folderName
, @use32bitruntime = @is32bit
, @reference_id = NULL  -- SSIS catalog environment
, @execution_id = @ssisExecutionId OUTPUT

-- write SSIS execution ID to log
EXEC sprockit.[LogExecutionProperty]
  @executionId = @executionId
, @propertyName = 'SsisExecutionId'
, @propertyValue = @ssisExecutionId

-- make [start_execution] wait for the package to finish
EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
  @execution_id = @ssisExecutionId
, @object_type = 50  -- system parameter
, @parameter_name = N'SYNCHRONIZED'
, @parameter_value = 1

-- if the package has a "$Package::SprockitExecutionId" parameter, pass it @sprockitExecutionId
IF EXISTS (
  SELECT *
  FROM SSISDB.[catalog].folders f 
    INNER JOIN SSISDB.[catalog].projects proj ON proj.folder_id = f.folder_id
    INNER JOIN SSISDB.[catalog].packages pkg ON pkg.project_id = proj.project_id
    INNER JOIN SSISDB.[catalog].object_parameters params 
      ON params.project_id = proj.project_id
      AND params.object_type = 30  -- a package
      AND params.[object_name] = pkg.[name]
  WHERE f.[name] = @folderName
  AND proj.[name] = @projectName
  AND pkg.[name] = @packageName
  AND params.parameter_name = 'SprockitExecutionId'
)
BEGIN

  EXEC sprockit.[LogExecutionProperty]
    @executionId = @executionId
  , @propertyName = 'PassedSprockitExecutionId'
  , @propertyValue = 'true'

  EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
    @execution_id = @ssisExecutionId
  , @object_type = 30  -- package parameter
  , @parameter_name = N'SprockitExecutionId'
  , @parameter_value = @executionId

END

-- execute the package (and wait for it to finish)
EXEC [SSISDB].[catalog].[start_execution] 
  @execution_id = @ssisExecutionId

/*
 * handle completion
 */
-- check package status & finish if successful...
IF (
  SELECT [status] 
  FROM [SSISDB].[catalog].[executions] 
  WHERE execution_id = @ssisExecutionId
) = 7  -- succeeded
  RETURN 0

-- ...otherwise log errors and raise one for Sprockit to handle.
INSERT INTO sprockit.[Event] (
  EventDateTime
, EventSource
, Severity
, [Message]
, ExecutionId
)  
SELECT  
  message_time
, event_message_id + ' ' + CAST(event_message_id AS VARCHAR)
, 200
, [message]
, @executionId
FROM SSISDB.[catalog].event_messages
--WHERE event_name = 'OnError'
WHERE message_type = 120  -- event_name not populated for failure loading package
AND operation_id = @ssisExecutionId

RAISERROR('The package failed.', 11, 1)
RETURN 1
