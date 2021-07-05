CREATE PROCEDURE sprockit__internal_ManageLogs.[test GIVEN retention period zero THEN no batches deleted]
AS

-- ARRANGE
UPDATE sprockit.Property
SET PropertyValue = 0
WHERE PropertyName = 'LogRetentionPeriod'

SELECT *
INTO #expected
FROM sprockit.Batch;

-- ACT
EXEC sprockit._internal_ManageLogs

-- ASSERT
SELECT *
INTO #actual
FROM sprockit.Batch;

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual';
