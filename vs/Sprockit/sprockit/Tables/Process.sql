CREATE TABLE [sprockit].[Process] (
    [ProcessId]        INT            IDENTITY (1, 1) NOT NULL,
    [ProcessGroup]     INT            CONSTRAINT [DF__sprockit_Process__ProcessGroup] DEFAULT ((1)) NOT NULL,
    [ProcessPath]      NVARCHAR (850) NOT NULL,
    [ProcessType]      NVARCHAR (10)  NOT NULL,
    [IsValidator]      BIT            CONSTRAINT [DF__sprockit_Process__IsValidator] DEFAULT ((0)) NOT NULL,
    [Status]           NVARCHAR (20)  CONSTRAINT [DF___sprockit_Process___Status__] DEFAULT ('Done') NOT NULL,
    [ErrorCount]       INT            CONSTRAINT [DF__sprockit_Process__ErrorCount] DEFAULT ((0)) NOT NULL,
    [LastStatusUpdate] DATETIME       CONSTRAINT [DF__Process__LastSta__5832119F] DEFAULT (getutcdate()) NOT NULL,
    [LastExecutionId]  INT            NULL,
    [AvgDuration]      INT            CONSTRAINT [DF___sprockit_Process__AvgDuration] DEFAULT ((0)) NOT NULL,
    [BranchWeight]     INT            CONSTRAINT [DF__sprockit_Process__BranchWeight] DEFAULT ((0)) NOT NULL,
    [IsEnabled]        BIT            CONSTRAINT [DF__sprockit_Process__IsEnabled] DEFAULT ((1)) NOT NULL,
    [Priority]         TINYINT        CONSTRAINT [DF__sprockit_Process__Priority] DEFAULT ((100)) NOT NULL,
    CONSTRAINT [PK__sprockit_Process] PRIMARY KEY CLUSTERED ([ProcessId] ASC),
    CONSTRAINT [FK__sprockit_Process__ProcessType] FOREIGN KEY ([ProcessType]) REFERENCES [sprockit].[ProcessType] ([ProcessType]),
    CONSTRAINT [UQ__sprockit_Process__ProcessPath] UNIQUE NONCLUSTERED ([ProcessPath] ASC)
);









