CREATE PROCEDURE sprockit.[SqlAgent_StartProcessHandler] (
  @batchId INT
) AS

DECLARE @jobName NVARCHAR(255) = DB_NAME() + '_SprockitHandler_' 
  + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), GETUTCDATE(), 121), '-', ''), ' ', ''), ':', '') 

DECLARE @handler TABLE (
  HandlerId INT
, ProcessGroup INT
)

INSERT INTO @handler (
  HandlerId
, ProcessGroup
)
EXEC sprockit.RegisterHandler 
  @batchId = @batchId
, @externalId = @jobName

DECLARE @cmd NVARCHAR(255)
DECLARE @dbName NVARCHAR(128)

-- get job details
SELECT 
  @cmd = 'EXEC sprockit.ProcessHandler @handlerId = ' + CAST(HandlerId AS VARCHAR) + ', @processGroup = ' + CAST(ProcessGroup AS VARCHAR)
, @dbName = DB_NAME()
FROM @handler

-- create the job
EXEC msdb.dbo.sp_add_job 
  @job_name = @jobName
, @delete_level = 1 -- delete job on successful completion
  
-- add the handler SP call as the job's step
EXEC msdb.dbo.sp_add_jobstep 
  @job_name = @jobName
, @step_name = 'Run process handler'
, @subsystem = 'TSQL'
, @database_name = @dbName
, @command = @cmd

-- add job server  
EXEC msdb.dbo.sp_add_jobserver 
  @job_name = @jobName
, @server_name = N'(LOCAL)'  
  
-- start the job
EXEC msdb.dbo.sp_start_job 
  @job_name = @jobName
