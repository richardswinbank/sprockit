/*
 * sprockit.[SqlAgent_ExecuteProcedure]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Execute a local stored procedure
 */
 
CREATE PROCEDURE sprockit.SqlAgent_ExecuteProcedure (
  @processPath NVARCHAR(1024)
, @executionId INT
) AS

-- determine if the SP has a @sprockitExecutionId parameter
DECLARE @hasParameter INT

DECLARE @sql NVARCHAR(MAX) = 'SELECT @hasParameter = COUNT(*)
FROM [' + PARSENAME(@processPath, 3) + '].sys.parameters
WHERE [object_id] = OBJECT_ID(@processPath, ''P'')
AND [name] = ''@sprockitExecutionId'''

EXEC sp_executesql
  @stmt = @sql
, @parameters = N'@hasParameter INT OUTPUT, @processPath NVARCHAR(400)'
, @hasParameter = @hasParameter OUTPUT
, @processPath = @processPath

-- if it has a @sprockitExecutionId parameter, pass it, otherwise call the SP with no args
IF @hasParameter = 1
BEGIN

  EXEC sprockit.[LogExecutionProperty]
    @executionId = @executionId
  , @propertyName = 'PassedSprockitExecutionId'
  , @propertyValue = 'true'

  EXEC @processPath @sprockitExecutionId = @executionId

END
ELSE
  EXEC @processPath