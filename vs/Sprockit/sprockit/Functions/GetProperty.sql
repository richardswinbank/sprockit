/*
 * sprockit.[GetProperty]
 * Copyright (c) 2015-2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Retrieve PropertyValue from sprockit.Property for a specified PropertyName
 */

CREATE FUNCTION sprockit.[GetProperty] (
  @propertyName NVARCHAR(128)
) 
RETURNS NVARCHAR(MAX)
AS
BEGIN

  DECLARE @propertyValue NVARCHAR(MAX)

  SELECT 
    @propertyValue = PropertyValue 
  FROM sprockit.Property
  WHERE PropertyName = @propertyName

  IF @propertyValue IS NULL 
  BEGIN 
    DECLARE @errorMsg NVARCHAR(255) = 'Property ''' + @propertyName + ''' is not defined.'
    DECLARE @i INT = CAST(@errorMsg AS INT) -- dirty trick to throw a fatal error
  END

  RETURN @propertyValue

END
