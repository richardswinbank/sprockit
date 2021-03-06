﻿CREATE PROCEDURE sprockit_Execution.[test ASSERT EndStatus is nullable]
AS

--ACT
INSERT INTO [sprockit].[Execution] (
  [ProcessId]
, [HandlerId]
, [ExecutionProperties]
, [StartDateTime]
, [EndDateTime]
, [ProcessType]
, [EndStatus]
, [AvgDuration]
, [BranchWeight]
, [IsEnabled]
, [Priority]
) 
SELECT
  [ProcessId]
, [HandlerId]
, '<Properties/>'
, GETUTCDATE()
, GETUTCDATE()
, [ProcessType]
, NULL
, 0
, 0
, 0
, 0
FROM sprockit_Execution.TestParams

-- ASSERT
-- (no error)