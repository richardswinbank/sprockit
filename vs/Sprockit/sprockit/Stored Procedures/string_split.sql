/*
 * sprockit.[string_split]
 * Copyright (c) 2020 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Emulate string_split for pre-SQL 2016 environments
 */
 
CREATE FUNCTION [sprockit].[string_split] (
  @list VARCHAR(MAX)
, @delim CHAR(1) = ','
) RETURNS TABLE
AS RETURN

WITH cte AS (
  SELECT
    ROW_NUMBER() OVER (ORDER BY N) AS FieldNumber
  , N AS Offset
  FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY [object_id]) AS N FROM sys.all_columns
  ) n
  WHERE N <= LEN(@list)
  AND SUBSTRING(@list, N, 1) = @delim

  UNION SELECT 0,0
), bounds AS (
  SELECT
    cte.Offset + 1 AS Offset
  , COALESCE(nxt.Offset, LEN(@list) + 1) - cte.Offset - 1 AS [Length]
  , CAST(
      CASE 
        WHEN (
          SELECT COUNT(*) FROM sys.all_columns
        ) < LEN(@list)
          THEN 'need more INTs!'
      END AS INT) AS ForceError
  FROM cte
    LEFT JOIN cte nxt ON nxt.FieldNumber = cte.FieldNumber + 1
)
SELECT 
  SUBSTRING(@list, Offset, [Length]) AS [value]
, ROW_NUMBER() OVER (ORDER BY Offset) AS [index]
FROM bounds

