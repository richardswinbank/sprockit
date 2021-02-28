/*
 * sprockit.[GetExecutionProperty]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Shred execution property value from XML
 */
 
CREATE FUNCTION [sprockit].[GetExecutionProperty] (
  @propertyName NVARCHAR(128)
, @properties XML(sprockit.Properties)
) RETURNS TABLE
AS RETURN (

  SELECT TOP 1
    Property.value('@value', 'NVARCHAR(4000)') AS PropertyValue
  FROM @properties.nodes('/Properties/Property') properties (Property)
  WHERE Property.value('@name', 'NVARCHAR(128)') = @propertyName

)