CREATE PROCEDURE sprockit_ReleaseProcess.[setup]
AS

DECLARE @batchId INT = 17
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791

EXEC tSQLt.FakeTable @TableName = 'sprockit.Batch', @Defaults = 1

INSERT INTO sprockit.Batch (
  BatchId
, ProcessGroup
) VALUES (
  @batchId
, @processGroup
)

EXEC tSQLt.FakeTable @TableName = 'sprockit.Handler', @Defaults = 1

INSERT INTO sprockit.Handler (
  HandlerId
, BatchId
) VALUES (
  @handlerId
, @batchId
)

EXEC tSQLt.FakeTable 
  @TableName = 'sprockit.Execution'
, @Identity = 1
, @Defaults = 1

EXEC tSQLt.FakeTable @TableName = 'sprockit.Reservation', @Defaults = 1

EXEC tSQLt.FakeTable @TableName = 'sprockit.Process', @Defaults = 1

INSERT INTO sprockit.Process (
  ProcessId
, ProcessGroup
, ErrorCount
, ProcessType
, ProcessPath
, [Status]
) VALUES
  (31, @processGroup, 2, 'SomeType', '/My/Process/Path', 'Not ready')
, (32, @processGroup, 2, 'SomeType', '/My/Other/Process/Path', 'Ready')
, (33, @processGroup, 2, 'OtherType', '[Some].[Different].[Process]', 'Not ready')
