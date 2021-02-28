CREATE PROCEDURE sprockit_Process.setup
AS

DECLARE @processGroup INT = 74

DECLARE @processType NVARCHAR(10) = 'SomeType'

INSERT INTO sprockit.ProcessType (
  ProcessType
) VALUES (
  @processType
)

SELECT 
  @processGroup AS ProcessGroup
, @processType AS ProcessType
INTO sprockit_Process.TestParams
