CREATE PROCEDURE [sprockit].[UpdateMetrics] (
  @processGroup INT
)
AS

SET NOCOUNT ON

/*
 * update average durations (rolling)
 */
;WITH avgDurations AS (
  SELECT 
    e.ProcessId
  , AVG(DATEDIFF(SECOND, e.StartDateTime, e.EndDateTime)) AS AvgDuration
  FROM sprockit.Execution e
  WHERE e.EndStatus = 'Done'
  AND e.StartDateTime > GETUTCDATE() - 7
  GROUP BY e.ProcessId
)
UPDATE p
SET AvgDuration = IIF(p.IsEnabled = 0, 0, ad.AvgDuration)
FROM sprockit.Process p
  INNER JOIN avgDurations ad ON ad.ProcessId = p.ProcessId
WHERE p.ProcessGroup = @processGroup

/*
 * update branch weights with the longest single path duration from each process
 */
CREATE TABLE #executionPaths (
  PathId INT IDENTITY PRIMARY KEY
, ProcessPath NVARCHAR(850)
, ExecutionPath NVARCHAR(1024)
)

DECLARE @i INT = -1

-- find leaf processes
INSERT INTO #executionPaths (
  ProcessPath
, ExecutionPath
)
SELECT
  p.ProcessPath
, CAST(p.ProcessId AS NVARCHAR(1024)) AS ExecutionPath
FROM sprockit.Process p
  LEFT JOIN sprockit.DependencyStatus(@processGroup) pd ON pd.PredecessorPath = p.ProcessPath
WHERE p.ProcessGroup = @processGroup
AND pd.PredecessorPath IS NULL  -- no dependants

-- assemble paths to all processes from leaves
WHILE @@ROWCOUNT > 0
BEGIN

  SET @i += 1

  INSERT INTO #executionPaths (
    ProcessPath
  , ExecutionPath
  )
  SELECT
    pd.PredecessorPath
  , CAST(pd.PredecessorId AS NVARCHAR) + ',' + xp.ExecutionPath
  FROM #executionPaths xp
    INNER JOIN sprockit.DependencyStatus(@processGroup) pd ON pd.ProcessPath = xp.ProcessPath
  WHERE LEN(xp.ExecutionPath) - LEN(REPLACE(xp.ExecutionPath, ',', '')) = @i 

END

;WITH pathLengths AS (
  SELECT 
    xp.PathId
  , xp.ProcessPath
  , SUM(IIF(p.IsEnabled = 0, 0, p.AvgDuration)) AS PathLength
  FROM #executionPaths xp
    CROSS APPLY string_split(xp.ExecutionPath, ',') spl
    INNER JOIN sprockit.Process p ON p.ProcessId = spl.[value]
  GROUP BY 
    xp.PathId
  , xp.ProcessPath
), branchWeights AS (
  SELECT
    ProcessPath 
  , MAX(PathLength) AS BranchWeight
  FROM pathLengths
  GROUP BY ProcessPath
)
UPDATE p
SET BranchWeight = bw.BranchWeight
FROM branchWeights bw
  INNER JOIN sprockit.Process p ON p.ProcessPath = bw.ProcessPath