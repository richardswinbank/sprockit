CREATE PROCEDURE sprockit_ReserveProcess.[test GIVEN non-PK error THEN exception rethrown]
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

ALTER TABLE sprockit.Reservation 
ALTER COLUMN HandlerId TINYINT  -- force non-PK error

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

EXEC tSQLt.ExpectException @ExpectedMessagePattern = '% rethrown by sprockit.usp_RethrowError: %'

-- ACT
INSERT INTO #actual (
  ExecutionId
, ProcessType
, ProcessPath
, DataWatermark
)
EXEC sprockit.ReserveProcess @handlerId = @handlerId
