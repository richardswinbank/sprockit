/*
 * create process manager agent job
 */
DECLARE @dbName NVARCHAR(128) = DB_NAME()
DECLARE @jobName NVARCHAR(128) = [sprockit].GetProperty('SqlAgent_ProcessGroup1Manager')

IF NOT EXISTS (
  SELECT *
  FROM msdb.dbo.sysjobs
  WHERE name = @jobName
)
BEGIN

  -- create the job
  EXEC msdb.dbo.sp_add_job
    @job_name = @jobName
  , @owner_login_name = N'sa'
  
  -- add the handler SP call as the job's step
  EXEC msdb.dbo.sp_add_jobstep 
    @job_name = @jobName
  , @step_name = 'Run process manager'
  , @subsystem = 'TSQL'
  , @database_name = @dbName
  , @command = 'EXEC sprockit.SqlAgent_ProcessManager @processGroup = 1'

  -- add job server  
  EXEC msdb.dbo.sp_add_jobserver 
    @job_name = @jobName
  , @server_name = N'(LOCAL)'  
      
END

DECLARE @stepName NVARCHAR(128) = 'Start new ETL batch'

-- add initial bootstrap step if not present
IF NOT EXISTS (
  SELECT *
  FROM msdb.dbo.sysjobsteps js
    INNER JOIN msdb.dbo.sysjobs j ON j.job_id = js.job_id
  WHERE j.[name] = @jobName
  AND js.[step_name] = @stepName
)
  EXEC msdb.dbo.sp_add_jobstep 
    @job_name = @jobName
  , @step_id = 1
  , @step_name = @stepName
  , @subsystem = 'TSQL'
  , @database_name = @dbName
  , @command = 'EXEC [sprockit].[PrepareNewBatch]'
  , @on_success_action = 3  -- go to next step

