CREATE PROCEDURE [sprockit_Property].[test WHEN two rows updated THEN update fails]
AS
 
-- ARRANGE
DECLARE @PropertyName1 NVARCHAR(128) = 'MyNewProperty1_' + CONVERT(varchar, getutcdate(), 121);
DECLARE @PropertyName2 NVARCHAR(128) = 'MyNewProperty2_' + CONVERT(varchar, getutcdate(), 121);

INSERT INTO sprockit.Property (
  PropertyName
, PropertyValue
, DataType
, [Description]
) VALUES
  (@PropertyName1, 1234, 'INT', '');

INSERT INTO sprockit.Property (
  PropertyName
, PropertyValue
, DataType
, [Description]
) VALUES
  (@PropertyName2, 2345, 'INT', '');

-- ACT
EXEC tSQLt.ExpectException @ExpectedMessage = 'Batch property updates are not permitted.';

UPDATE sprockit.Property
SET PropertyValue = 1
WHERE PropertyName IN (
  @PropertyName1
, @PropertyName2
);

-- ASSERT
