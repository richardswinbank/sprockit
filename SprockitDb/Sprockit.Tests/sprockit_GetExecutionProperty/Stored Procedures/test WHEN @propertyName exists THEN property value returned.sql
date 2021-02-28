CREATE PROCEDURE [sprockit_GetExecutionProperty].[test WHEN @propertyName exists THEN property value returned]
AS

-- ARRANGE
DECLARE @propertyName NVARCHAR(128) = 'MySecondProperty'
DECLARE @properties XML = '<Properties><Property name="MySecondProperty" value="value2" /><Property name="MyThirdProperty" value="value3" /></Properties>'

SELECT 'value2' AS PropertyValue
INTO #expected

-- ACT
SELECT * 
INTO #actual
FROM sprockit.GetExecutionProperty(@propertyName, @properties)

-- ASSERT
EXEC tSQLt.AssertEqualsTable 
  @Expected = '#expected'
, @Actual = '#actual'
