CREATE PROCEDURE sprockit.DeserialiseProcesses(
  @processes XML
) AS

DROP TABLE IF EXISTS #processes

SELECT
  t.c.value('(@Path)[1]', 'NVARCHAR(850)') AS ProcessPath
, t.c.value('(@Type)[1]', 'NVARCHAR(10)') AS ProcessType
, t.c.value('(@Group)[1]', 'INT') AS ProcessGroup
, t.c.value('(@DefaultWatermark)[1]', 'NVARCHAR(255)') AS DefaultWatermark
, t.c.value('(@IsEnabled)[1]', 'BIT') AS IsEnabled
, t.c.value('(@Priority)[1]', 'TINYINT') AS [Priority]
, t.c.query('./Requires') AS DependsOn
INTO #processes
FROM (
  SELECT @processes.query('/Processes/Process') AS Processes
) p CROSS APPLY p.Processes.nodes('/Process') t(c)

BEGIN TRY

  BEGIN TRANSACTION

    -- insert new processes & update existing
    MERGE INTO sprockit.Process tgt
    USING #processes src
      ON src.ProcessPath = tgt.ProcessPath
    WHEN MATCHED THEN 
      UPDATE
      SET ProcessType  = src.ProcessType
        , ProcessGroup = src.ProcessGroup
        , DefaultWatermark  = src.DefaultWatermark
        , CurrentWatermark  = CASE WHEN tgt.CurrentWatermark IS NULL THEN src.DefaultWatermark ELSE tgt.CurrentWatermark END
        , IsEnabled = src.IsEnabled
        , [Priority] = src.[Priority]
    WHEN NOT MATCHED BY TARGET THEN
      INSERT (
        ProcessPath
      , ProcessType
      , ProcessGroup
      , DefaultWatermark
      , CurrentWatermark
      , IsEnabled
      , [Priority]
      ) VALUES (
        src.ProcessPath
      , src.ProcessType
      , src.ProcessGroup
      , src.DefaultWatermark
      , src.DefaultWatermark
      , src.IsEnabled
      , src.[Priority]
      );

    -- merge dependencies
    WITH src AS (
      SELECT DISTINCT
        p.ProcessId
      , d.ProcessId AS DependsOn
      FROM #processes np
        CROSS APPLY np.DependsOn.nodes('/Requires/PriorProcess') t(c)
        LEFT JOIN sprockit.Process p ON p.ProcessPath = np.ProcessPath
        LEFT JOIN sprockit.Process d ON d.ProcessPath = t.c.value('(@Path)[1]', 'NVARCHAR(850)')
    )
    MERGE INTO sprockit.ProcessDependency tgt
    USING src
      ON src.ProcessId = tgt.ProcessId
      AND src.DependsOn = tgt.DependsOn
    WHEN NOT MATCHED BY TARGET THEN
      INSERT (
        ProcessId
      , DependsOn
      ) VALUES (
        src.ProcessId
      , src.DependsOn
      )
    WHEN NOT MATCHED BY SOURCE THEN
      DELETE;

    -- delete removed processes
    DELETE e
    FROM sprockit.Process p
      LEFT JOIN #processes np ON np.ProcessPath = p.ProcessPath
      INNER JOIN sprockit.Execution e ON e.ProcessId = p.ProcessId
    WHERE np.ProcessPath IS NULL

    DELETE p
    FROM sprockit.Process p
      LEFT JOIN #processes np ON np.ProcessPath = p.ProcessPath
    WHERE np.ProcessPath IS NULL

  COMMIT

END TRY
BEGIN CATCH

  ROLLBACK;
  THROW;

END CATCH
