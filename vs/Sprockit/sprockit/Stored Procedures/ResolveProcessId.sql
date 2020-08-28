/*
 * sprockit.[ResolveProcessId]
 * Copyright (c) 2018-2019 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Identify a process using (maybe only some of) its process path.
 */
 
CREATE PROCEDURE [sprockit].[ResolveProcessId] (
  @processIdentifier NVARCHAR(1024)
, @debug BIT = 0
)
AS

SET NOCOUNT ON

DECLARE @processId INT = -1

-- check if @nameFragment is really a (valid) process ID (allows callers 
-- to pass in a process ID or name without first having to check what it is)
BEGIN TRY

  SELECT 
    @processId = ProcessId
  FROM sprockit.Process
  WHERE ProcessId = @processIdentifier

  IF @processId > 0    -- if we get this far, it's an INT at least
  BEGIN
    SELECT @processId AS ProcessId
    RETURN   -- and if > 0, it's a valid process ID
  END

END TRY
BEGIN CATCH
  -- it's not even an INT - let's move on and try to find it by name
END CATCH

DECLARE @namePattern NVARCHAR(1024) = '%' +
  REPLACE(
    REPLACE(
      @processIdentifier
    , '['
    , '\['
	)
  , '_'
  , '\_'
  ) + '%'
 
IF @debug = 1 PRINT 'Looking for processes with FqProcessName LIKE ''' + @namePattern + ''''

DECLARE @matches INT = 0
DECLARE @msg NVARCHAR(MAX) = ''

SELECT
  @processId = ProcessId
, @matches += 1
, @msg += '
  - ' + ProcessPath + ' (process ID ' + CAST(ProcessId AS VARCHAR) + ')'
FROM sprockit.Process
WHERE ProcessPath LIKE @namePattern ESCAPE '\'

SET @msg = 'Pattern ''' + @processIdentifier + ''' matches ' +
  CASE @matches
    WHEN 0 THEN 'no process names'
    WHEN 1 THEN 'process ID ' + CAST(@processId AS VARCHAR) + @msg
    ELSE 'more than one process name:' + @msg
  END
 
IF @matches <> 1
BEGIN
  SET @msg = REPLACE(@msg, '%', '%%')
  RAISERROR(@msg, 11, 1)
  RETURN -1
END

IF @debug = 1 PRINT @msg
SELECT @processId AS ProcessId