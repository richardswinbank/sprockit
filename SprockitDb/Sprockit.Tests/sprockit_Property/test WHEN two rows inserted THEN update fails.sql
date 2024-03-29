CREATE PROCEDURE [sprockit_Property].[test WHEN two rows inserted THEN update fails]
AS
 
-- ARRANGE
DECLARE @PropertyName1 NVARCHAR(128) = 'MyNewProperty1_' + CONVERT(varchar, getutcdate(), 121);
DECLARE @PropertyName2 NVARCHAR(128) = 'MyNewProperty2_' + CONVERT(varchar, getutcdate(), 121);

-- ACT
EXEC tSQLt.ExpectException @ExpectedMessage = 'Batch property updates are not permitted.';
 
INSERT INTO sprockit.Property (
  PropertyName
, PropertyValue
, DataType
, [Description]
) VALUES
  (@PropertyName1, 1234, 'INT', '')
, (@PropertyName2, 2345, 'INT', '');

-- ASSERT
