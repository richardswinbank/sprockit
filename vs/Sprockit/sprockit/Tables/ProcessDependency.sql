CREATE TABLE [sprockit].[ProcessDependency] (
    [DependencyId] INT IDENTITY (1, 1) NOT NULL,
    [ProcessId]    INT NOT NULL,
    [DependsOn]    INT NOT NULL,
    CONSTRAINT [PK__sprockit_Dependency] PRIMARY KEY NONCLUSTERED ([DependencyId] ASC),
    CONSTRAINT [FK__DependsOn] FOREIGN KEY ([DependsOn]) REFERENCES [sprockit].[Process] ([ProcessId]),
    CONSTRAINT [FK__ProcessId] FOREIGN KEY ([ProcessId]) REFERENCES [sprockit].[Process] ([ProcessId])
);






GO


