CREATE PROCEDURE sprockit_Property.[test ASSERT scheduler property name exists]
AS

-- ACT
DECLARE @propertyValue NVARCHAR(255) = sprockit.GetProperty('ProcessSchedulerSpName')

-- ASSERT
EXEC tSQLt.AssertEquals 
  @Expected = 'sprockit.EnqueueProcesses'
, @Actual = @propertyValue
