﻿CREATE PROCEDURE sprockit_ReserveProcess.[test GIVEN ready process reserved THEN no process returned]
AS

-- ARRANGE
DECLARE @batchId INT = 17
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791

EXEC tSQLt.FakeTable @TableName = 'sprockit.Process', @Defaults = 1

INSERT INTO sprockit.Process (
  ProcessId
, ProcessGroup
, ProcessType
, ProcessPath
, [Status]
) VALUES
  (31, @processGroup, 'SomeType', '/My/Process/Path', 'Not ready')
, (32, @processGroup, 'SomeType', '/My/Other/Process/Path', 'Ready')
, (33, @processGroup, 'OtherType', '[Some].[Different].[Process]', 'Not ready')

EXEC tSQLt.FakeTable 'sprockit.Reservation'

INSERT INTO sprockit.Reservation (
  ProcessId
, HandlerId
) VALUES (
  32
, @handlerId
)

CREATE TABLE #actual (
  ExecutionId INT
, ProcessType NVARCHAR(10)
, ProcessPath NVARCHAR(850)
, DataWatermark NVARCHAR(255)
)

SELECT *
INTO #expected
FROM #actual

INSERT INTO #expected (
  ExecutionId
) VALUES (
  -1
)

-- ACT
INSERT INTO #actual (
  ExecutionId
, ProcessType
, ProcessPath
, DataWatermark
)
EXEC sprockit.ReserveProcess @handlerId = @handlerId

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#Actual'
