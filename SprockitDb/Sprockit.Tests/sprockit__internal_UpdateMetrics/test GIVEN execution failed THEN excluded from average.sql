CREATE PROCEDURE sprockit__internal_UpdateMetrics.[test GIVEN execution failed THEN excluded from average]
AS

-- ARRANGE
UPDATE sprockit.Execution
SET EndStatus = 'Errored'
WHERE ProcessId = 3
AND StartDateTime > DATEADD(DAY, -4, GETUTCDATE());

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
, (3,  95)  -- (90 + 100) / 2
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
