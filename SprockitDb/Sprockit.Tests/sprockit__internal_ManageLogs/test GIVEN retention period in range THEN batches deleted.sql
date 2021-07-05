CREATE PROCEDURE sprockit__internal_ManageLogs.[test GIVEN retention period in range THEN batches deleted]
AS

-- ARRANGE
DECLARE @cutoff DATETIME = '2021-07-02 00:00';

UPDATE sprockit.Property
SET PropertyValue = DATEDIFF(DAY, @cutoff, GETUTCDATE()) + 1
WHERE PropertyName = 'LogRetentionPeriod';

SELECT *
INTO #expected
FROM sprockit.Batch
WHERE CreatedDateTime >= @cutoff;

-- ACT
EXEC sprockit._internal_ManageLogs

-- ASSERT
SELECT *
INTO #actual
FROM sprockit.Batch
WHERE CreatedDateTime >= @cutoff;

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual';
