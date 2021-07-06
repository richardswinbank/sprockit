﻿CREATE PROCEDURE sprockit__internal_ManageLogs.[test GIVEN retention period negative THEN no executions deleted]
AS

-- ARRANGE
UPDATE sprockit.Property
SET PropertyValue = -50
WHERE PropertyName = 'LogRetentionPeriod'

SELECT BatchId
INTO #expected
FROM sprockit.Execution;

-- ACT
EXEC sprockit._internal_ManageLogs

-- ASSERT
SELECT BatchId
INTO #actual
FROM sprockit.Execution;

EXEC tSQLt.AssertEqualsTable
  @Expected = '#expected'
, @Actual = '#actual';
