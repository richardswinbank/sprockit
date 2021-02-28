CREATE PROCEDURE [sprockit_ReserveProcess].[test GIVEN last process disabled THEN no process returned]
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
  (31, @processGroup, 0, 'SomeType', '/My/Process/Path', 'Ready')
, (32, @processGroup, 0, 'SomeType', '/My/Other/Process/Path', 'Ready')
, (33, @processGroup, 0, 'OtherType', '[Some].[Different].[Process]', 'Ready')

CREATE TABLE [sprockit_ReserveProcess].actual (
  ExecutionId INT
, ProcessType NVARCHAR(10)
, ProcessPath NVARCHAR(850)
, DataWatermark NVARCHAR(255)
)

SELECT *
INTO #expected
FROM [sprockit_ReserveProcess].actual

INSERT INTO #expected (ExecutionId) VALUES (-1)

-- ACT
DECLARE @sql NVARCHAR(MAX) = 'EXEC sprockit.ReserveProcess @handlerId = ' + CAST(@handlerId AS VARCHAR)
EXEC dbo.InsertExec 
  @insertInto = '[sprockit_ReserveProcess].actual'
, @exec = @sql

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '[sprockit_ReserveProcess].actual'
