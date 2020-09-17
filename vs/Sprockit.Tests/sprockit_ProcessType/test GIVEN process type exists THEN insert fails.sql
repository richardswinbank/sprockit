CREATE PROCEDURE sprockit_ProcessType.[test GIVEN process type is null THEN insert fails]
AS

-- ARRANGE
DECLARE @processType NVARCHAR(10) = NULL

DELETE FROM sprockit.ProcessType

INSERT INTO sprockit.ProcessType (
  ProcessType
) VALUES (
  'NewType'
)

-- EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Cannot insert the value NULL into column ''ProcessType'', table ''%.sprockit.ProcessType''%'

-- ACT
INSERT INTO sprockit.ProcessType (
  ProcessType
) VALUES (
  @processType
)
