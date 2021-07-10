CREATE PROCEDURE [sprockit_Property].[test WHEN property deleted THEN event logged]
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

EXEC tSQLt.FakeTable @TableName = 'sprockit.Event';

DECLARE @expected INT = 1;
DECLARE @msgPattern NVARCHAR(255) = 'Deleted property "' + @PropertyName1 + '" %';

-- ACT
DELETE FROM sprockit.Property
WHERE PropertyName = @PropertyName1;

-- ASSERT
DECLARE @actual INT = 0;
DECLARE @message NVARCHAR(255) = '';

SELECT
  @actual = COUNT(*)
, @message = MAX([Message])
FROM sprockit.[Event];

EXEC tSQLt.AssertEquals 
  @Expected = @expected
, @Actual = @actual;

EXEC tSQLt.AssertLike 
  @ExpectedPattern = @msgPattern
, @Actual = @Message;
