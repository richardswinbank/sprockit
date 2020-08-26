create procedure sprockit.RethrowError

AS

-- check that we're in an error state - if not, there's nothing to do
DECLARE @errNum INT = ERROR_NUMBER()
IF @errNum IS NULL 
  RETURN 

-- assemble parameters for a new error, wrapping the details of the old one
DECLARE 
  @msg NVARCHAR(4000) = N'Error %d rethrown by sprockit.usp_RethrowError: Level %d, State %d, Procedure %s, Line %d, ' 
                      + 'Message: ' + ERROR_MESSAGE()
, @number INT = ERROR_NUMBER()
, @level INT = ERROR_SEVERITY()
, @state INT = ERROR_STATE()
, @proc NVARCHAR(200) = COALESCE(ERROR_PROCEDURE(), '<unknown>')
, @line INT = ERROR_LINE()

-- throw the new error
RAISERROR (@msg, @level, 1
, @number  -- original error number
, @level   -- original severity
, @state   -- original state
, @proc    -- source object name
, @line    -- line number of error in source object
)