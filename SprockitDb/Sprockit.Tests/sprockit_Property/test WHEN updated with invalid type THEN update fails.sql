CREATE PROCEDURE [sprockit_Property].[test WHEN updated with invalid type THEN update fails]
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
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%not a valid data type%';

UPDATE sprockit.Property
SET DataType = 'NINT'
WHERE PropertyName = @PropertyName1;

-- ASSERT
