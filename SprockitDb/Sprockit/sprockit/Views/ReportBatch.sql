﻿/*
 * sprockit.[ReportBatch]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Batch details for monitoring dashboard.
 */

CREATE VIEW [sprockit].[ReportBatch] 
AS

SELECT 
  BatchId
, ProcessGroup
, CONVERT(NVARCHAR, batch.[CreatedDateTime], 120) + ' - Group ' + CAST(batch.ProcessGroup AS NVARCHAR) + ' - Batch ' + CAST(batch.BatchId AS NVARCHAR) AS BatchName
, [CreatedDateTime]
, COALESCE(EndDateTime, GETUTCDATE()) AS EndDateTime
FROM sprockit.Batch
WHERE DATEADD(DAY, 14, [CreatedDateTime]) > GETUTCDATE()
