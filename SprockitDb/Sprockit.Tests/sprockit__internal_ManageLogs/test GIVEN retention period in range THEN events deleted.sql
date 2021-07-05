CREATE PROCEDURE sprockit__internal_ManageLogs.[test GIVEN retention period in range THEN events deleted]
AS

-- ARRANGE
DECLARE @cutoff DATETIME = '2021-07-02 00:00';

UPDATE sprockit.Property
SET PropertyValue = DATEDIFF(DAY, @cutoff, GETUTCDATE()) + 1
WHERE PropertyName = 'LogRetentionPeriod';

SELECT *
INTO #expected
FROM sprockit.[Event]
WHERE EventDateTime >= @cutoff;

-- ACT
EXEC sprockit._internal_ManageLogs

-- ASSERT
SELECT *
INTO #actual
FROM sprockit.[Event];

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual';
