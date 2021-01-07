CREATE TABLE [sprockit].[ProcessDependency] (
    [DependencyId] INT IDENTITY (1, 1) NOT NULL,
    [ProcessId]    INT NOT NULL,
    [DependsOn]    INT NOT NULL,
    CONSTRAINT [PK__sprockit_Dependency] PRIMARY KEY NONCLUSTERED ([DependencyId] ASC),
    CONSTRAINT [CK__sprockit_ProcessDependency__NoSelfDependency] CHECK ([ProcessId]<>[DependsOn]),
    CONSTRAINT [FK__DependsOn] FOREIGN KEY ([DependsOn]) REFERENCES [sprockit].[Process] ([ProcessId]),
    CONSTRAINT [FK__ProcessId] FOREIGN KEY ([ProcessId]) REFERENCES [sprockit].[Process] ([ProcessId]),
    CONSTRAINT [UQ__sprockit_ProcessDependency] UNIQUE NONCLUSTERED ([ProcessId] ASC, [DependsOn] ASC)
);








GO
CREATE TRIGGER [sprockit].[NoCircularDependencies]
ON [sprockit].[ProcessDependency]
AFTER INSERT, UPDATE
AS
BEGIN

  SET NOCOUNT ON

  IF OBJECT_ID('tempdb..#successors') IS NOT NULL
    DROP TABLE #successors

  CREATE TABLE #successors (
    ProcessId INT
  , DownstreamProcessId INT
  , ExecutionPath NVARCHAR(MAX)
  , PRIMARY KEY (ProcessId, DownstreamProcessId)
  --, CONSTRAINT CK_NoCircularDependencies CHECK (ProcessId != DownstreamProcessId)
  )

  INSERT INTO #successors (
    ProcessId
  , DownstreamProcessId
  , ExecutionPath
  )
  SELECT
    pd.DependsOn AS ProcessId
  , pd.ProcessId AS DownstreamProcessId
  , p.ProcessPath + ' -> ' + d.ProcessPath
  FROM sprockit.ProcessDependency pd
    INNER JOIN sprockit.Process p ON p.ProcessId = pd.DependsOn 
    INNER JOIN sprockit.Process d ON d.ProcessId = pd.ProcessId 

  DECLARE @msg NVARCHAR(MAX)

  WHILE 1 = 1
  BEGIN

    INSERT INTO #successors (
      ProcessId
    , DownstreamProcessId
    , ExecutionPath
    )
    SELECT DISTINCT
      s.ProcessId
    , pd.ProcessId
    , MAX(s.ExecutionPath + ' -> ' + p.ProcessPath)
    FROM #successors s
      INNER JOIN sprockit.ProcessDependency pd ON pd.DependsOn = s.DownstreamProcessId
      INNER JOIN sprockit.Process p ON p.ProcessId = pd.ProcessId
      LEFT JOIN #successors x
        ON x.ProcessId = s.ProcessId
        AND x.DownstreamProcessId = pd.ProcessId
    WHERE x.ProcessId IS NULL
    GROUP BY
      s.ProcessId
    , pd.ProcessId

    IF @@ROWCOUNT = 0
      BREAK;

    SET @msg = ''

    SELECT 
      @msg += '
Circular dependency detected around ' + ExecutionPath
    FROM #successors
    WHERE ProcessId = DownstreamProcessId

    IF LEN(@msg) > 0
    BEGIN
      RAISERROR(@msg, 11, 1)
      BREAK
    END

  END

END