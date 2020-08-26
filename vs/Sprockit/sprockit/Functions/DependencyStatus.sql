CREATE FUNCTION [sprockit].[DependencyStatus] (
  @processGroup INT
) RETURNS TABLE
AS RETURN

SELECT
  this.ProcessId
, this.ProcessPath
, this.[Status] AS ProcessStatus
, pred.ProcessId AS PredecessorId
, pred.ProcessPath AS PredecessorPath
, pred.[Status] AS PredecessorStatus
FROM [sprockit].[ProcessDependency] pd
  INNER JOIN sprockit.Process this ON this.ProcessId = pd.ProcessId
  INNER JOIN sprockit.Process pred ON pred.ProcessId = pd.DependsOn
WHERE pred.ProcessGroup = this.ProcessGroup
AND pred.ProcessGroup = @processGroup