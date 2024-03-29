CREATE PROCEDURE [sprockit_Property].[test WHEN updated with invalid value THEN update fails.sql]
AS
 
-- ARRANGE
DECLARE @PropertyName1 NVARCHAR(128) = 'MyNewProperty1_' + CONVERT(varchar, getutcdate(), 121);

INSERT INTO sprockit.Property (
  PropertyName
, PropertyValue
, DataType
, [Description]
) VALUES
  (@PropertyName1, 1234, 'INT', '');

-- ACT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%not of that type%';

UPDATE sprockit.Property
SET PropertyValue = 'not an int'
WHERE PropertyName = @PropertyName1;

-- ASSERT
