/*
 * sprockit.[UninstallSprockit]
 * Copyright (c) 2015-2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Remove Sprockit from the current database
 */
 
CREATE PROCEDURE [sprockit].[UninstallSprockit] (
  @databaseName NVARCHAR(128)  -- safety check
) AS

SET NOCOUNT ON

IF COALESCE(@databaseName, '') <> DB_NAME()
BEGIN
  DECLARE @msg NVARCHAR(1024) = '[sprockit].[UninstallSprockit] requires parameter @databaseName to match the current database';
  RAISERROR(@msg, 11, 1);
  RETURN 1;
END

IF OBJECT_ID('[sprockit].[GetProperty]') IS NOT NULL DROP FUNCTION [sprockit].[GetProperty]
IF OBJECT_ID('[sprockit].[DependencyStatus]') IS NOT NULL DROP FUNCTION [sprockit].[DependencyStatus]
IF OBJECT_ID('[sprockit].[GetExecutionProperty]') IS NOT NULL DROP FUNCTION [sprockit].[GetExecutionProperty]

IF OBJECT_ID('[sprockit].[ManageLogs]') IS NOT NULL DROP PROCEDURE [sprockit].ManageLogs
IF OBJECT_ID('[sprockit].[LogEvent]') IS NOT NULL DROP PROCEDURE [sprockit].[LogEvent]
IF OBJECT_ID('[sprockit].[ResolveProcessId]') IS NOT NULL DROP PROCEDURE [sprockit].[ResolveProcessId]
IF OBJECT_ID('[sprockit].[RethrowError]') IS NOT NULL DROP PROCEDURE [sprockit].[RethrowError]
IF OBJECT_ID('[sprockit].[Rewind]') IS NOT NULL DROP PROCEDURE [sprockit].[Rewind]
IF OBJECT_ID('[sprockit].[SetExecutionProperty]') IS NOT NULL DROP PROCEDURE [sprockit].[SetExecutionProperty]
IF OBJECT_ID('[sprockit].[UpdateMetrics]') IS NOT NULL DROP PROCEDURE [sprockit].[UpdateMetrics]
IF OBJECT_ID('[sprockit].[EnqueueProcesses]') IS NOT NULL DROP PROCEDURE [sprockit].[EnqueueProcesses]
IF OBJECT_ID('[sprockit].[SetControlLimits]') IS NOT NULL DROP PROCEDURE [sprockit].[SetControlLimits]
IF OBJECT_ID('[sprockit].[LogProcessMetric]') IS NOT NULL DROP PROCEDURE [sprockit].[LogProcessMetric]
IF OBJECT_ID('[sprockit].[DeserialiseProcesses]') IS NOT NULL DROP PROCEDURE [sprockit].[DeserialiseProcesses]
IF OBJECT_ID('[sprockit].[PrepareBatchRestart]') IS NOT NULL DROP PROCEDURE [sprockit].[PrepareBatchRestart]
IF OBJECT_ID('[sprockit].[ReleaseProcess]') IS NOT NULL DROP PROCEDURE [sprockit].[ReleaseProcess]
IF OBJECT_ID('[sprockit].[PrepareNewBatch]') IS NOT NULL DROP PROCEDURE [sprockit].[PrepareNewBatch]
IF OBJECT_ID('[sprockit].[ReserveProcess]') IS NOT NULL DROP PROCEDURE [sprockit].[ReserveProcess]

IF OBJECT_ID('[sprockit].[ReportProcessControlChart]') IS NOT NULL DROP VIEW [sprockit].[ReportProcessControlChart]
IF OBJECT_ID('[sprockit].[ReportFinalStatus]') IS NOT NULL DROP VIEW [sprockit].[ReportFinalStatus]
IF OBJECT_ID('[sprockit].[ReportExecutionProperty]') IS NOT NULL DROP VIEW [sprockit].[ReportExecutionProperty]
IF OBJECT_ID('[sprockit].[ReportExecution]') IS NOT NULL DROP VIEW [sprockit].[ReportExecution]
IF OBJECT_ID('[sprockit].[ReportEvent]') IS NOT NULL DROP VIEW [sprockit].[ReportEvent]
IF OBJECT_ID('[sprockit].[ReportBatch]') IS NOT NULL DROP VIEW [sprockit].[ReportBatch]
IF OBJECT_ID('[sprockit].[ReportParallelism]') IS NOT NULL DROP VIEW [sprockit].[ReportParallelism]

IF OBJECT_ID('[sprockit].[Property]') IS NOT NULL DROP TABLE [sprockit].[Property]
IF OBJECT_ID('[sprockit].[RetryableError]') IS NOT NULL DROP TABLE [sprockit].[RetryableError]
IF OBJECT_ID('[sprockit].[Event]') IS NOT NULL DROP TABLE [sprockit].[Event]
IF OBJECT_ID('[sprockit].[ProcessMetric]') IS NOT NULL DROP TABLE [sprockit].[ProcessMetric]
IF OBJECT_ID('[sprockit].[ProcessDependency]') IS NOT NULL DROP TABLE [sprockit].[ProcessDependency]
IF OBJECT_ID('[sprockit].[ProcessControlLimits]') IS NOT NULL DROP TABLE [sprockit].[ProcessControlLimits]
IF OBJECT_ID('[sprockit].[ProcessParameter]') IS NOT NULL DROP TABLE [sprockit].[ProcessParameter]
IF OBJECT_ID('[sprockit].[Reservation]') IS NOT NULL DROP TABLE [sprockit].[Reservation]
IF OBJECT_ID('[sprockit].[Execution]') IS NOT NULL DROP TABLE [sprockit].[Execution]
IF OBJECT_ID('[sprockit].[Process]') IS NOT NULL DROP TABLE [sprockit].[Process]
IF OBJECT_ID('[sprockit].[ProcessType]') IS NOT NULL DROP TABLE [sprockit].[ProcessType]
IF OBJECT_ID('[sprockit].[Batch]') IS NOT NULL DROP TABLE [sprockit].[Batch]

IF EXISTS (
  SELECT *
  FROM sys.xml_schema_collections c
    INNER JOIN sys.schemas s ON s.[schema_id] = c.[schema_id]
  WHERE s.[name] = 'sprockit'
  AND c.[name] = 'Properties'
)
DROP XML SCHEMA COLLECTION sprockit.Properties;

IF OBJECT_ID('[sprockit].[UninstallSprockit]') IS NOT NULL DROP PROCEDURE [sprockit].[UninstallSprockit];

DROP SCHEMA sprockit;
