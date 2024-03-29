CREATE PROCEDURE sprockit__internal_UpdateMetrics.[test GIVEN revised dependencies THEN branch weight changes]
AS

-- ARRANGE
/*
Reverse dependency order between 2 & 3
  From: 1 -> 2 -> 3
              \
               4 -> 5
  To: 1 -> 2 <- 3
            \   
             4 -> 5 
*/
UPDATE sprockit.ProcessDependency
SET ProcessId = 2
  , DependsOn = 3
WHERE ProcessId = 3;

CREATE TABLE #expected (
  ProcessId	INT
, BranchWeight INT
);

INSERT INTO #expected (
  ProcessId
, BranchWeight
) VALUES 
  (1, 420)
, (2, 395)
, (3, 500)
, (4, 330)
, (5, 185)
;

-- ACT
EXEC sprockit._internal_UpdateMetrics 
  @processGroup = 1;

-- ASSERT
SELECT 
  ProcessId
, BranchWeight
INTO #actual
FROM sprockit.Process;

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual';
