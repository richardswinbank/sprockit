CREATE PROCEDURE sprockit_Property.[test ASSERT SqlAgent_MaxConcurrentHandlers property exists]
AS

-- ACT
DECLARE @propertyValue NVARCHAR(255) = sprockit.GetProperty('SqlAgent_MaxConcurrentHandlers')

-- ASSERT
EXEC tSQLt.AssertEquals 
  @Expected = '4'
, @Actual = @propertyValue
