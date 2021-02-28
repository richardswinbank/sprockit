CREATE PROCEDURE [sprockit_GetExecutionProperty].[test WHEN @properties is NULL THEN no rows returned]
AS

-- ARRANGE
DECLARE @propertyName NVARCHAR(128) = 'MySecondProperty'
DECLARE @properties XML = NULL

SELECT 'value2' AS PropertyValue
INTO #expected
WHERE 0 = 1

-- ACT
SELECT * 
INTO #actual
FROM sprockit.GetExecutionProperty(@propertyName, @properties)

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
