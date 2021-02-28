CREATE PROCEDURE sprockit_ProcessType.[test GIVEN process type does not exist THEN insert succeeds]
AS

-- ARRANGE
DECLARE @processType NVARCHAR(10) = 'NewType2'

DELETE FROM sprockit.ProcessType

INSERT INTO sprockit.ProcessType (
  ProcessType
) VALUES (
  'NewType'
)

SELECT ProcessType
INTO #expected
FROM sprockit.ProcessType
UNION SELECT @processType

-- ACT
INSERT INTO sprockit.ProcessType (
  ProcessType
) VALUES (
  @processType
)

SELECT ProcessType
INTO #actual
FROM sprockit.ProcessType

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
