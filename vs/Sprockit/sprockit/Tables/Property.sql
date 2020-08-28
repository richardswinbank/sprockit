  CREATE TABLE sprockit.[Property] (
	[PropertyName] NVARCHAR(128) PRIMARY KEY
  , [PropertyValue] NVARCHAR(MAX) NOT NULL
  , [DataType] NVARCHAR(128) NOT NULL
  , [Description] NVARCHAR(512) NOT NULL
  )

  GO

CREATE TRIGGER sprockit.PropertyChanged
ON sprockit.Property
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  SET NOCOUNT ON

  DECLARE @msg NVARCHAR(MAX)
  
  DECLARE @ins INT, @del INT  
  SELECT @ins = COUNT(*) FROM inserted
  SELECT @del = COUNT(*) FROM deleted

  IF @ins = 0 AND @del = 0  -- e.g. delete from empty table
    RETURN  -- nothing to do
  
  -- forbid changes to more than one row
  IF @ins > 1 OR @del > 1
  BEGIN
    RAISERROR('Batch property updates are not permitted.', 11, 1)
    ROLLBACK TRANSACTION
    RETURN
  END
  
  -- check that the value is castable to the specified type
  IF @ins = 1
  BEGIN
    DECLARE @sql NVARCHAR(MAX)
    
    -- try to cast the value to its declared type
    -- (assign to variable to suppress output)
    SELECT @sql = 'DECLARE @var ' + i.DataType + ' = CAST(''' 
      + REPLACE(i.PropertyValue, '''', '''''') + ''' AS ' + i.DataType + ')'   
    FROM inserted i
    
    BEGIN TRY
      EXEC (@sql)     
    END TRY
    BEGIN CATCH
  
      SELECT @msg = 'Either ''' +  i.DataType + ''' is not a valid data type, or ' 
        + REPLACE(i.PropertyValue, '''', '''''') + ' is not of that type.'
      FROM inserted i
      
      RAISERROR(@msg, 11, 1)
      ROLLBACK TRANSACTION      
      RETURN

    END CATCH
  END

  /*
   * handle specific change types
   */
  -- updates
  IF @ins = 1 AND @del = 1
  BEGIN
    -- don't allow the property name to change
    IF (
      SELECT COUNT(*)
      FROM inserted i
        INNER JOIN deleted d ON i.PropertyName = d.PropertyName
      ) != 1
    BEGIN
      RAISERROR('PropertyName cannot be changed.', 11, 1)
      ROLLBACK TRANSACTION
      RETURN
    END
    
    -- log a property value change, if any
    DECLARE @callerDbId INT  = CAST(SUBSTRING(CONTEXT_INFO(), 1, 4) AS INT)
    DECLARE @callerObjId INT = CAST(SUBSTRING(CONTEXT_INFO(), 5, 4) AS INT)
    DECLARE @calledFrom NVARCHAR(500) = 
      COALESCE(
        ' (via ' + QUOTENAME(DB_NAME(@callerDbId)) 
          + '.' + QUOTENAME(OBJECT_SCHEMA_NAME(@callerObjId, @callerDbId))
          + '.' + QUOTENAME(OBJECT_NAME(@callerObjId, @callerDbId)) + ')'
      , '')

    DECLARE @propName NVARCHAR(128)
    DECLARE @propType NVARCHAR(255)

    SELECT 
      @msg = QUOTENAME(SYSTEM_USER) + ' updated property ''' + REPLACE(i.PropertyName, '''', '''''') + ''''
        + @calledFrom + '; value changed from ''' + REPLACE(d.PropertyValue, '''', '''''')
        + ''' to ''' + REPLACE(i.PropertyValue, '''', '''''') + ''''
    , @propName = i.PropertyName
    , @propType = i.DataType
    FROM inserted i
      INNER JOIN deleted d ON i.PropertyName = d.PropertyName
      
  END
  
  -- inserts
  ELSE IF @ins = 1 -- new property
  BEGIN
    SELECT 
      @msg = 'Created property ''' + i.PropertyName 
        + '''; value ''' + i.PropertyValue + ''''
    , @propName = i.PropertyName
    , @propType = i.DataType
    FROM inserted i
  END

  -- deletes
  ELSE IF @del = 1 -- deleted property
  BEGIN
    SELECT 
      @msg = 'Deleted property ''' + d.PropertyName 
        + '''; value ''' + d.PropertyValue + ''''
    , @propName = d.PropertyName
    , @propType = d.DataType
    FROM deleted d
  END

  DECLARE @eventSource NVARCHAR(255) = QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID))

  EXEC sprockit.LogEvent 
    @message = @msg
  , @eventSource = @eventSource

END
