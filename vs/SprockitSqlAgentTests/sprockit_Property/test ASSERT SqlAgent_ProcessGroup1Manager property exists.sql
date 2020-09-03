CREATE PROCEDURE sprockit_Property.[test ASSERT SqlAgent_ProcessGroup1Manager property exists]
AS

-- ACT
DECLARE @propertyValue NVARCHAR(255) = sprockit.GetProperty('SqlAgent_ProcessGroup1Manager')

-- ASSERT
EXEC tSQLt.AssertLike
  @ExpectedPattern = 'Run Sprockit (%, process group 1)'
, @Actual = @propertyValue
