GO

WITH src AS (
  SELECT * FROM (VALUES
    ('SQL', 'SQL Server stored procedure')
  , ('SSIS', 'SSIS package in local catalog')
  ) t (ProcessType, [Description])
)
MERGE INTO sprockit.ProcessType tgt
USING src
  ON src.ProcessType = tgt.ProcessType
WHEN MATCHED THEN
  UPDATE
  SET [Description] = src.[Description]
WHEN NOT MATCHED BY TARGET THEN
  INSERT (
    ProcessType
  , [Description]
  ) VALUES (
    src.ProcessType
  , src.[Description]
  )
;