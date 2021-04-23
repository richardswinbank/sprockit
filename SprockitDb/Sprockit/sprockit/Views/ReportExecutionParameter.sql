/*
 * sprockit.[ReportExecutionParameter]
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Execution parameter values for monitoring dashboard.
 */

CREATE VIEW sprockit.ReportExecutionParameter
AS

SELECT 
  x.ExecutionId
, p.parameter.[value]('(@name)[1]','NVARCHAR(255)') AS PropertyName
, p.parameter.[value]('(@value)[1]','NVARCHAR(255)') AS PropertyValue
FROM sprockit.Execution x
  CROSS APPLY x.ExecutionParameters.nodes('/Parameters/Parameter') AS p(parameter)