GO

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
  ('ProcessSchedulerSpName', 'sprockit.EnqueueProcesses', 'NVARCHAR(255)', 'Name of SP to set processes Ready')
, ('MaximumParallelProcesses', '20', 'INT', 'Maximum number of processes allow to run simultaneously')
, ('LogRetentionPeriod', '0', 'INT', 'Number of days for which to retain log records (0 = forever)')

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
