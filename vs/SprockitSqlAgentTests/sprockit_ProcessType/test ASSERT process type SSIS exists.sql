CREATE PROCEDURE sprockit_ProcessType.[test ASSERT process type SSIS exists]
AS

-- ARRANGE
DECLARE @processType NVARCHAR(10) = 'SSIS'
DECLARE @expected INT = 1

-- ACT
DECLARE @actual INT = 0

SELECT 
  @actual = COUNT(*)
FROM sprockit.ProcessType
WHERE ProcessType = @processType

-- ASSERT
EXEC tSQLt.AssertEquals 
  @Expected = @expected
, @Actual = @actual
