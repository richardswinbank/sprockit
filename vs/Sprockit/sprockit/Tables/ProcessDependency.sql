CREATE TABLE [sprockit].[ProcessDependency] (
    [DependencyId] INT            IDENTITY (1, 1) NOT NULL,
    [ProcessPath]  NVARCHAR (850) NOT NULL,
    [DependsOn]    NVARCHAR (850) NOT NULL,
    CONSTRAINT [PK__sprockit_Dependency] PRIMARY KEY NONCLUSTERED ([DependencyId] ASC),
    CONSTRAINT [FK__DependsOn] FOREIGN KEY ([DependsOn]) REFERENCES [sprockit].[Process] ([ProcessPath]),
    CONSTRAINT [FK__ProcessPath] FOREIGN KEY ([ProcessPath]) REFERENCES [sprockit].[Process] ([ProcessPath])
);




GO
CREATE CLUSTERED INDEX [CI__sprockit_Dependency__ProcessPath]
    ON [sprockit].[ProcessDependency]([ProcessPath] ASC);

