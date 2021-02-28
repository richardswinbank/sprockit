CREATE PROCEDURE [sprockit_GetExecutionProperty].[test WHEN @propertyName not exists THEN no rows returned]
AS

-- ARRANGE
DECLARE @propertyName NVARCHAR(128) = 'MyNonExistentProperty'
DECLARE @properties XML = '<Properties><Property name="MySecondProperty" value="value2" /><Property name="MyThirdProperty" value="value3" /></Properties>'

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
