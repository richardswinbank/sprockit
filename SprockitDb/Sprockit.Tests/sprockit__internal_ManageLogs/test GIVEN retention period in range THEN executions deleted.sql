CREATE PROCEDURE sprockit__internal_ManageLogs.[test GIVEN retention period in range THEN executions deleted]
AS

-- ARRANGE
DECLARE @cutoff DATETIME = '2021-07-02 00:00';

UPDATE sprockit.Property
SET PropertyValue = DATEDIFF(DAY, @cutoff, GETUTCDATE()) + 1
WHERE PropertyName = 'LogRetentionPeriod';

SELECT x.BatchId
INTO #expected
FROM sprockit.Execution x
  INNER JOIN sprockit.Batch b ON b.BatchId = x.BatchId
WHERE b.CreatedDateTime >= @cutoff;

-- ACT
EXEC sprockit._internal_ManageLogs

-- ASSERT
SELECT x.BatchId
INTO #actual
FROM sprockit.Execution x
  INNER JOIN sprockit.Batch b ON b.BatchId = x.BatchId
WHERE b.CreatedDateTime >= @cutoff;

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual';
