CREATE TABLE sprockit.ProcessParameter (
  ProcessId INT NOT NULL CONSTRAINT FK__sprockit_ProcessParameter__ProcessId FOREIGN KEY REFERENCES sprockit.Process (ProcessId)
, ParameterName NVARCHAR(128) NOT NULL CONSTRAINT CK__sprockit_ProcessParameter__ParameterName CHECK (ParameterName NOT LIKE 'Sprockit%')
, ParameterValue NVARCHAR(4000) NOT NULL
, CONSTRAINT PK__sprockit_ProcessParameter PRIMARY KEY (
    ProcessId
  , ParameterName
  )
)
