CREATE PROCEDURE sprockit_ReserveProcess.[setup]
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

EXEC tSQLt.FakeTable @TableName = 'sprockit.ProcessType'

INSERT INTO sprockit.ProcessType (
  ProcessType
, HasHandler
) VALUES 
  ('SomeType', 1)
, ('OtherType', 1)
