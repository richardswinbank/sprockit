/*
 * sprockit.[DeserialiseProcesses]
 * Copyright (c) 2020-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Deserialise process list from XML & sync to database
 */
 
CREATE PROCEDURE [sprockit].[DeserialiseProcesses] (
  @processes XML
) AS

SET NOCOUNT ON

IF @processes IS NULL
BEGIN
  RAISERROR ('@processes cannot be NULL', 11, 1)
  RETURN 1
END

IF OBJECT_ID('tempdb..#processes') IS NOT NULL
  DROP TABLE #processes

SELECT
  t.c.value('(@Path)[1]', 'NVARCHAR(850)') AS ProcessPath
, t.c.value('(@Type)[1]', 'NVARCHAR(10)') AS ProcessType
, t.c.value('(@Group)[1]', 'INT') AS ProcessGroup
, t.c.value('(@DefaultWatermark)[1]', 'NVARCHAR(255)') AS DefaultWatermark
, COALESCE(t.c.value('(@Priority)[1]', 'TINYINT'), 100) AS [Priority]
, COALESCE(t.c.value('(@LogPropertyUpdates)[1]', 'BIT'), 0) AS LogPropertyUpdates
, t.c.query('./Requires') AS Requires
, t.c.query('./Produces') AS Produces
INTO #processes
FROM (
  SELECT @processes.query('/Processes/Process') AS Processes
) p CROSS APPLY p.Processes.nodes('/Process') t(c)

BEGIN TRY

  BEGIN TRANSACTION

    IF (
      SELECT COUNT(*) FROM sprockit.ProcessType
    ) = 0
    INSERT INTO sprockit.ProcessType (
      ProcessType
    ) 
    SELECT DISTINCT 
      ProcessType
    FROM #processes p

    -- insert new processes & update existing
    MERGE INTO sprockit.Process tgt
    USING #processes src
      ON src.ProcessPath = tgt.ProcessPath
    WHEN MATCHED THEN 
      UPDATE
      SET ProcessType  = src.ProcessType
        , ProcessGroup = src.ProcessGroup
        , DefaultWatermark  = src.DefaultWatermark
        , CurrentWatermark =
            CASE 
              WHEN src.DefaultWatermark IS NULL THEN NULL
              ELSE COALESCE(tgt.CurrentWatermark, src.DefaultWatermark)
            END
        , [Priority] = src.[Priority]
        , LogPropertyUpdates = src.LogPropertyUpdates
    WHEN NOT MATCHED BY TARGET THEN
      INSERT (
        ProcessPath
      , ProcessType
      , ProcessGroup
      , DefaultWatermark
      , CurrentWatermark
      , [Priority]
      , LogPropertyUpdates
      ) VALUES (
        src.ProcessPath
      , src.ProcessType
      , src.ProcessGroup
      , src.DefaultWatermark
      , src.DefaultWatermark
      , src.[Priority]
      , src.LogPropertyUpdates
      );

    -- collect dependencies
    SELECT
      p.ProcessId
    , np.ProcessPath
    , input.ProcessId AS DependsOn
    , inputs.c.[value]('(@Path)[1]', 'NVARCHAR(850)') AS DependsOnPath
    INTO #dependencies
    FROM #processes np
      CROSS APPLY np.Requires.nodes('/Requires/Input') inputs(c)
      LEFT JOIN sprockit.Process p ON p.ProcessPath = np.ProcessPath
      LEFT JOIN sprockit.Process input ON input.ProcessPath = inputs.c.[value]('(@Path)[1]', 'NVARCHAR(850)')

    UNION

    SELECT
      [output].ProcessId
    , outputs.c.[value]('(@Path)[1]', 'NVARCHAR(850)')
    , p.ProcessId AS DependsOn
    , np.ProcessPath
    FROM #processes np
      CROSS APPLY np.Produces.nodes('/Produces/Output') outputs(c)
      LEFT JOIN sprockit.Process p ON p.ProcessPath = np.ProcessPath
      LEFT JOIN sprockit.Process [output] ON [output].ProcessPath = outputs.c.[value]('(@Path)[1]', 'NVARCHAR(850)')
    ;

    DECLARE @msg NVARCHAR(MAX) = N'';

    WITH err AS (
      SELECT ProcessPath 
      FROM #dependencies
      WHERE ProcessId IS NULL
	  
	  UNION 
	  
	  SELECT DependsOnPath
      FROM #dependencies
      WHERE DependsOn IS NULL
	)
    SELECT 
      @msg += CHAR(13) + CHAR(10) + ' - ' + ProcessPath
    FROM err;

    IF LEN(@msg) > 0
    BEGIN
      SET @msg = 'Unable to resolve process(es):' + @msg
      RAISERROR(@msg, 11, 1)
    END

    -- merge dependencies
    MERGE INTO sprockit.ProcessDependency tgt
    USING #dependencies src
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
  EXEC sprockit.RethrowError;

END CATCH
