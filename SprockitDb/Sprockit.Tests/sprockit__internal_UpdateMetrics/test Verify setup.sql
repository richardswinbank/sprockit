CREATE PROCEDURE sprockit__internal_UpdateMetrics.[test Verify setup]
AS

-- ARRANGE
CREATE TABLE #expected (
  ProcessId	INT
, AvgDuration INT
, BranchWeight INT
);

INSERT INTO #expected (
  ProcessId
, AvgDuration
, BranchWeight
) VALUES 
  (1,  25, 420)
, (2,  65, 395)
, (3, 105, 105)
, (4, 145, 330)
, (5, 185, 185)
;

-- ACT
EXEC sprockit._internal_UpdateMetrics 
  @processGroup = 1;

-- ASSERT
SELECT 
  ProcessId
, AvgDuration
, BranchWeight
INTO #actual
FROM sprockit.Process;

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual';
