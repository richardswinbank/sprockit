CREATE PROCEDURE sprockit_ProcessType.[test GIVEN process type exists THEN insert fails]
AS

-- ARRANGE
DECLARE @processType NVARCHAR(10) = 'NewType'

DELETE FROM sprockit.ProcessType

INSERT INTO sprockit.ProcessType (
  ProcessType
) VALUES (
  'NewType'
)

-- EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Violation of PRIMARY KEY constraint ''PK__sprockit_ProcessType''. Cannot insert duplicate key in object ''sprockit.ProcessType''.%'

-- ACT
INSERT INTO sprockit.ProcessType (
  ProcessType
) VALUES (
  @processType
)
