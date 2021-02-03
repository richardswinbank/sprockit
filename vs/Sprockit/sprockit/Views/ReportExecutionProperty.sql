/*
 * sprockit.[ReportExecutionProperty]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Execution property details for monitoring dashboard.
 */

CREATE VIEW sprockit.ReportExecutionProperty
AS

SELECT 
  x.ExecutionId
, p.property.[value]('(@name)[1]','NVARCHAR(255)') AS PropertyName
, p.property.[value]('(@value)[1]','NVARCHAR(255)') AS PropertyValue
FROM sprockit.Execution x
  CROSS APPLY x.ExecutionProperties.nodes('/Properties/Property') AS p(property)