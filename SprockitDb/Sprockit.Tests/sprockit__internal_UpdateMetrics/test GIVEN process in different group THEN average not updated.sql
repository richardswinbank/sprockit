CREATE PROCEDURE sprockit__internal_UpdateMetrics.[test GIVEN process in different group THEN average not updated]
AS

-- ARRANGE
UPDATE sprockit.Process
SET ProcessGroup = 2
WHERE ProcessId = 3;

CREATE TABLE #expected (
  ProcessId	INT
, AvgDuration INT
);

INSERT INTO #expected (
  ProcessId
, AvgDuration
) VALUES 
  (1,  25)
, (2,  65)
, (3,   0)  -- unchanged
, (4, 145)
, (5, 185)
;

-- ACT
EXEC sprockit._internal_UpdateMetrics 
  @processGroup = 1;

-- ASSERT
SELECT 
  ProcessId
, AvgDuration
INTO #actual
FROM sprockit.Process;

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual';

