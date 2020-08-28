/*
 * configure Sprockit properties
 */
-- define properties
DECLARE @properties TABLE (
  [PropertyName] NVARCHAR(128) PRIMARY KEY
, [PropertyValue] NVARCHAR(MAX)
, [DataType] NVARCHAR(128)
, [Description] NVARCHAR(512)
)

INSERT INTO @properties (
  PropertyName
, PropertyValue
, DataType
, [Description]
) VALUES
  ('SqlAgent_MaxConcurrentHandlers', '4', 'SMALLINT', 'Maximum number of Sprockit handlers allowed to run concurrently')
, ('SqlAgent_ProcessGroup1Manager', 'Run Sprockit (' + DB_NAME() + ', process group 1)', 'NVARCHAR(128)', 'Name of Sprockit process group 1 manager agent job')

DECLARE @propertyName NVARCHAR(128)

-- add properties we don't have, one at a time (trigger prevents batch update)
WHILE 1 = 1
BEGIN

  SET @propertyName = NULL

  SELECT TOP 1 
    @propertyName = PropertyName
  FROM @properties

  IF @propertyName IS NULL
    BREAK  -- we're done

  INSERT INTO sprockit.Property ( 
    PropertyName
  , PropertyValue
  , DataType
  , [Description]
  )
  SELECT
    p.PropertyName
  , p.PropertyValue
  , p.DataType
  , p.[Description]
  FROM @properties p
    LEFT JOIN sprockit.Property props ON p.PropertyName = props.PropertyName
  WHERE p.PropertyName = @propertyName
  AND props.PropertyName IS NULL

  DELETE FROM @properties
  WHERE PropertyName = @propertyName

END
