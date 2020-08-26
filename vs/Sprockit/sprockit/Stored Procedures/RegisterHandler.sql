CREATE PROCEDURE [sprockit].[RegisterHandler] (
  @batchId INT
, @externalId NVARCHAR(255) = NULL
)
AS

SET NOCOUNT ON

INSERT INTO [sprockit].[Handler] (
  [BatchId]
, ExternalId
, [StartDateTime]
) VALUES (
  @batchId
, @externalId
, GETUTCDATE()
);

DECLARE @handlerId INT = SCOPE_IDENTITY();

SELECT 
  h.HandlerId
, b.ProcessGroup
FROM sprockit.Handler h
  INNER JOIN sprockit.Batch b ON b.BatchId = h.BatchId
WHERE h.HandlerId = @handlerId