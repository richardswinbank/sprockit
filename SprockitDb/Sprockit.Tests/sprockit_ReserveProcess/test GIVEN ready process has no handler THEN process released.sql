﻿CREATE PROCEDURE [sprockit_ReserveProcess].[test GIVEN ready process has no handler THEN process released]
AS

-- ARRANGE
DECLARE @batchId INT = 17
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791

EXEC tSQLt.FakeTable @TableName = 'sprockit.Process', @Defaults = 1

INSERT INTO sprockit.Process (
  ProcessId
, ProcessGroup
, IsEnabled
, ProcessType
, ProcessPath
, [Status]
) VALUES
  (31, @processGroup, 1, 'SomeType', '/My/Process/Path', 'Not ready')
, (32, @processGroup, 1, 'SomeType', '/My/Other/Process/Path', 'Ready')
, (33, @processGroup, 1, 'OtherType', '[Some].[Different].[Process]', 'Not ready')

UPDATE sprockit.ProcessType
SET HasHandler = 0
WHERE ProcessType = 'SomeType'

EXEC tSQLt.SpyProcedure 'sprockit.ReleaseProcess'

SELECT
  1 AS ExecutionId
, 'Done' AS EndStatus
INTO #expected

-- ACT
DECLARE @result TABLE (
  ExecutionId INT
, ProcessType NVARCHAR(10)
, ProcessPath NVARCHAR(850)
, DataWatermark NVARCHAR(255)
)

INSERT INTO @result (
  ExecutionId
, ProcessType
, ProcessPath
, DataWatermark
)
EXEC sprockit.ReserveProcess @handlerId = @handlerId

SELECT
  ExecutionId
, EndStatus
INTO #actual
FROM sprockit.ReleaseProcess_SpyProcedureLog

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
