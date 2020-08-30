CREATE PROCEDURE sprockit_ReserveProcess.[setup]
AS

DECLARE @batchId INT = 17
DECLARE @processGroup INT = 4
DECLARE @handlerId INT = 791

EXEC tSQLt.FakeTable 'sprockit.Batch'

INSERT INTO sprockit.Batch (
  BatchId
, ProcessGroup
) VALUES (
  @batchId
, @processGroup
)

EXEC tSQLt.FakeTable 'sprockit.Handler'

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
