/*
 * sprockit.[UnregisterHandler]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Unregister a completed process handler
 */
 
CREATE PROCEDURE [sprockit].[UnregisterHandler] (
  @handlerId INT 
, @endStatus NVARCHAR(20) = 'Done'
)
AS

UPDATE h
SET [EndDateTime] = GETUTCDATE()
  , [Status] = @endStatus
FROM [sprockit].[Handler] h
WHERE h.HandlerId = @handlerId