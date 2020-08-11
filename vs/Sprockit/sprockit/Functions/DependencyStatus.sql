
CREATE FUNCTION [sprockit].[DependencyStatus] (
  @processGroup INT
) RETURNS TABLE
AS RETURN

SELECT
  pd.ProcessPath
, this.ProcessId
, this.[Status] AS ProcessStatus
, pd.DependsOn AS PredecessorPath
, pred.ProcessId AS PredecessorId
, pred.[Status] AS PredecessorStatus
FROM [sprockit].[ProcessDependency] pd
  INNER JOIN sprockit.Process this ON this.ProcessPath = pd.ProcessPath
  INNER JOIN sprockit.Process pred ON pred.ProcessPath = pd.DependsOn
WHERE pred.ProcessGroup = this.ProcessGroup
AND pred.ProcessGroup = @processGroup