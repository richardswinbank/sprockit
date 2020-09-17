/*
 * sprockit.[RegisterHandler]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Register a new process handler for a specified batch
 */
 
CREATE PROCEDURE [sprockit].[RegisterHandler] (
  @batchId INT
, @externalId NVARCHAR(255) = NULL
)
AS

SET NOCOUNT ON

INSERT INTO [sprockit].[Handler] (
  [BatchId]
, ExternalId
) VALUES (
  @batchId
, @externalId
);

DECLARE @handlerId INT = SCOPE_IDENTITY();

SELECT 
  h.HandlerId
, b.ProcessGroup
FROM sprockit.Handler h
  INNER JOIN sprockit.Batch b ON b.BatchId = h.BatchId
WHERE h.HandlerId = @handlerId