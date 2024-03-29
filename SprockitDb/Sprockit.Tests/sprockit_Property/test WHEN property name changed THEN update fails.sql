CREATE PROCEDURE [sprockit_Property].[test WHEN property name changed THEN update fails]
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
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%PropertyName cannot be changed%';

UPDATE sprockit.Property
SET PropertyName = REPLACE(@PropertyName1, 'MyNewProperty1', 'MyNewProperty2')
WHERE PropertyName = @PropertyName1;

-- ASSERT
