CREATE PROCEDURE [sprockit].[ConfigureProcesses] (
  @processList XML
) AS
--*/

BEGIN TRY

  WITH src AS (
    SELECT
      p.pc.value('@path', 'NVARCHAR(4000)') AS ProcessPath
    , p.pc.value('@type', 'NVARCHAR(4000)') AS ProcessType
    FROM @processList.nodes('//ProcessList/Process') p(pc)
  )
  MERGE INTO sprockit.Process tgt
  USING src
    ON src.ProcessPath = tgt.ProcessPath
  WHEN MATCHED AND (tgt.ProcessType <> src.ProcessType) THEN 
    UPDATE
    SET ProcessType = src.ProcessType
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (
      ProcessPath
    , ProcessType
    ) VALUES (
      src.ProcessPath
    , src.ProcessType
    );

  WITH src AS (
    SELECT
      pr.ProcessId
	, dep.ProcessId AS DependsOn
    FROM @processList.nodes('//ProcessList/Process') p(pc)
      CROSS APPLY p.pc.nodes('Produces') AS o(oc)
	  LEFT JOIN sprockit.Process dep ON dep.ProcessPath = p.pc.value('@path', 'NVARCHAR(4000)')
	  LEFT JOIN sprockit.Process pr ON pr.ProcessPath = o.oc.value('Output[1]/@path', 'NVARCHAR(4000)')

	UNION 

    SELECT
      pr.ProcessId
	, dep.ProcessId AS DependsOn
    FROM @processList.nodes('//ProcessList/Process') p(pc)
      CROSS APPLY p.pc.nodes('Requires') AS o(oc)
	  LEFT JOIN sprockit.Process dep ON dep.ProcessPath = o.oc.value('Input[1]/@path', 'NVARCHAR(4000)')
	  LEFT JOIN sprockit.Process pr ON pr.ProcessPath = p.pc.value('@path', 'NVARCHAR(4000)')
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
	);

END TRY
BEGIN CATCH

  EXEC sprockit.RethrowError
 --RETURN -1

END CATCH