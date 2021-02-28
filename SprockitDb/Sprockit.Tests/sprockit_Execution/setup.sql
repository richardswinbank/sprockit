CREATE PROCEDURE sprockit_Execution.setup
AS

DECLARE @processGroup INT = 74

INSERT INTO sprockit.Batch (
  ProcessGroup
) VALUES (
  @processGroup
)

DECLARE @batchId INT = SCOPE_IDENTITY()

INSERT INTO sprockit.Handler (
  BatchId
) VALUES (
  @batchId
)

DECLARE @handlerId INT = SCOPE_IDENTITY()

DECLARE @processType NVARCHAR(10) = 'SomeType'

INSERT INTO sprockit.ProcessType (
  ProcessType
) VALUES (
  @processType
)

INSERT INTO sprockit.Process (
  ProcessPath
, ProcessType
, ProcessGroup
) VALUES (
  '/My/Process/Path'
, @processType
, @processGroup
)

DECLARE @processId INT = SCOPE_IDENTITY()

SELECT 
  @processGroup AS ProcessGroup
, @batchId AS BatchId
, @handlerId AS HandlerId
, @processId AS ProcessId
, @processType AS ProcessType
INTO sprockit_Execution.TestParams
