CREATE PROCEDURE [sprockit_ReserveProcess].[test GIVEN ready process THEN process marked Running]
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

SELECT 
  ProcessId
, CASE ProcessId WHEN 32 THEN 'Running' ELSE [Status] END AS [Status]
INTO #expected
FROM sprockit.Process

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
  ProcessId
, [Status]
INTO #actual
FROM sprockit.Process

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
