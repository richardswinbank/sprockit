/*
 * sprockit.[UpdateMetrics]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Recalculate scheduling metrics using the most recent execution history data.
 */

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
SET AvgDuration = CASE p.IsEnabled WHEN 0 THEN 0 ELSE ad.AvgDuration END
FROM sprockit.Process p
  INNER JOIN avgDurations ad ON ad.ProcessId = p.ProcessId
WHERE p.ProcessGroup = @processGroup

/*
 * update branch weights with the longest single path duration from each process
 */
CREATE TABLE #executionPaths (
  PathId INT IDENTITY PRIMARY KEY
, ProcessId INT
, ExecutionPath NVARCHAR(MAX)
, PathWeight INT
)

DECLARE @i INT = -1

-- find leaf processes
INSERT INTO #executionPaths (
  ProcessId
, ExecutionPath
, PathWeight
)
SELECT
  p.ProcessId
, CAST(p.ProcessId AS NVARCHAR) AS ExecutionPath
, p.AvgDuration
FROM sprockit.Process p
  LEFT JOIN sprockit.DependencyStatus(@processGroup) pd ON pd.PredecessorId = p.ProcessId
WHERE p.ProcessGroup = @processGroup
AND pd.PredecessorPath IS NULL  -- no dependants

-- assemble paths to all processes from leaves
WHILE @@ROWCOUNT > 0
BEGIN

  SET @i += 1

  INSERT INTO #executionPaths (
    ProcessId
  , ExecutionPath
  , PathWeight
  )
  SELECT
    pd.PredecessorId
  , CAST(pd.PredecessorId AS NVARCHAR) + ',' + xp.ExecutionPath
  , xp.PathWeight + p.AvgDuration
  FROM #executionPaths xp
    INNER JOIN sprockit.DependencyStatus(@processGroup) pd ON pd.ProcessId = xp.ProcessId
    INNER JOIN sprockit.Process p ON p.ProcessId = pd.PredecessorId
  WHERE LEN(xp.ExecutionPath) - LEN(REPLACE(xp.ExecutionPath, ',', '')) = @i 

END

;WITH branchWeights AS (
  SELECT
    ProcessId 
  , MAX(PathWeight) AS BranchWeight
  FROM #executionPaths
  GROUP BY ProcessId
)
UPDATE p
SET BranchWeight = bw.BranchWeight
FROM branchWeights bw
  INNER JOIN sprockit.Process p ON p.ProcessId = bw.ProcessId
