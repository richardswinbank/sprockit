CREATE PROCEDURE sprockit_GetProperty.[setup]
AS

EXEC tSQLt.FakeTable 'sprockit.Property'

INSERT INTO sprockit.Property (
  PropertyName
, PropertyValue
) VALUES
  ('prop1', 'val1')
, ('prop2', 'val2')
, ('prop3', 'val3')
