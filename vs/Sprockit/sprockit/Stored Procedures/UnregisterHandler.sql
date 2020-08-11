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