﻿
CREATE PROCEDURE [sprockit].[SerialiseProcesses]
AS

DECLARE @xml NVARCHAR(MAX) = N'';

WITH processes AS (
  SELECT
    (  
      SELECT 
        [ProcessPath] AS [Path]
      , [ProcessGroup] AS [Group]
      , [ProcessType] AS [Type]
      , [DefaultWatermark]
      , CASE [IsEnabled] WHEN 1 THEN 'true' ELSE 'false' END AS [IsEnabled]
      , [Priority]
      FROM [sprockit].[Process] AS [Process]
      WHERE ProcessId = p.ProcessId
      FOR XML AUTO
    ) AS Process
  , '<Requires>' + (
      SELECT
        PriorProcess.ProcessPath AS [Path]
      FROM sprockit.ProcessDependency pd
        INNER JOIN sprockit.Process PriorProcess ON PriorProcess.ProcessId = pd.DependsOn
      WHERE pd.ProcessId = p.ProcessId
      FOR XML AUTO
    ) + '</Requires>' AS ProcessInputs
  FROM sprockit.Process p
)
SELECT
  @xml += LEFT(CAST(Process AS NVARCHAR(MAX)), LEN(Process) - 2) + '>'
    + COALESCE(ProcessInputs, '')
    + '</Process>'
FROM processes;

SELECT CAST('<Processes>' + @xml + '</Processes>' AS XML) AS Processes