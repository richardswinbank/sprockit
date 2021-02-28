/*
 * sprockit.[SetControlLimits]
 * Copyright (c) 2020-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Calculate statistical process control limits from recent executions
 */
 
CREATE PROCEDURE sprockit.SetControlLimits (
  @processGroup INT
) AS

SELECT
  e.ProcessId
, m.MetricName
, m.MetricValue
, e.EndDateTime
INTO #metrics
FROM sprockit.ProcessMetric m
  INNER JOIN sprockit.Execution e ON e.ExecutionId = m.ExecutionId
WHERE e.EndDateTime > GETUTCDATE() - 30;

WITH outliers AS (
  SELECT ROW_NUMBER() OVER (
    PARTITION BY 
      ProcessId
    , MetricName
    ORDER BY MetricValue DESC
  ) highest
  FROM #metrics
)
DELETE FROM outliers
WHERE highest = 1;

WITH outliers AS (
  SELECT ROW_NUMBER() OVER (
    PARTITION BY 
      ProcessId
    , MetricName
    ORDER BY MetricValue ASC
  ) lowest
  FROM #metrics
)
DELETE FROM outliers
WHERE lowest = 1;

WITH src AS (
  SELECT 
    ProcessId
  , MetricName
  , AVG(MetricValue) - 3 * COALESCE(STDEV(MetricValue), 0) AS LowerControlLimit
  , AVG(MetricValue) AS Mean
  , AVG(MetricValue) + 3 * COALESCE(STDEV(MetricValue), 0) AS UpperControlLimit
  FROM #metrics
  GROUP BY
    ProcessId
  , MetricName
)
MERGE INTO sprockit.ProcessControlLimits tgt
USING src
  ON src.ProcessId = tgt.ProcessId
  AND src.MetricName = tgt.MetricName
WHEN MATCHED THEN 
  UPDATE
  SET LowerControlLimit = src.LowerControlLimit
    , Mean = src.Mean
    , UpperControlLimit = src.UpperControlLimit
    , LastUpdated = GETUTCDATE()
WHEN NOT MATCHED BY TARGET THEN 
  INSERT (
    ProcessId
  , MetricName
  , LowerControlLimit
  , Mean
  , UpperControlLimit
  ) VALUES (
    src.ProcessId
  , src.MetricName
  , src.LowerControlLimit
  , src.Mean
  , src.UpperControlLimit
  )
WHEN NOT MATCHED BY SOURCE THEN
  DELETE
;
