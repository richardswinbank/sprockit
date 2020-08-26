CREATE TABLE [sprockit].[Process] (
    [ProcessId]        INT            IDENTITY (1, 1) NOT NULL,
    [ProcessGroup]     INT            CONSTRAINT [DF_Process_ProcessGroup] DEFAULT ((1)) NOT NULL,
    [ProcessPath]      NVARCHAR (850) NOT NULL,
    [ProcessType]      NVARCHAR (10)  NOT NULL,
    [IsValidator]      BIT            CONSTRAINT [DF_Process_IsValidator] DEFAULT ((0)) NOT NULL,
    [Status]           NVARCHAR (20)  CONSTRAINT [DF__Process__Status__573DED66] DEFAULT ('Done') NOT NULL,
    [ErrorCount]       INT            CONSTRAINT [DF_Process_ErrorCount] DEFAULT ((0)) NOT NULL,
    [LastStatusUpdate] DATETIME       CONSTRAINT [DF__Process__LastSta__5832119F] DEFAULT (getutcdate()) NOT NULL,
    [LastExecutionId]  INT            NULL,
    [AvgDuration]      INT            CONSTRAINT [DF__Process__AvgDura__592635D8] DEFAULT ((0)) NOT NULL,
    [BranchWeight]     INT            CONSTRAINT [DF__Process__BranchW__5A1A5A11] DEFAULT ((0)) NOT NULL,
    [IsEnabled]        BIT            CONSTRAINT [DF__Process__IsEnabl__5B0E7E4A] DEFAULT ((1)) NOT NULL,
    [Priority]         TINYINT        CONSTRAINT [DF__Process__Priorit__5C02A283] DEFAULT ((100)) NOT NULL,
    CONSTRAINT [PK__Process__1B39A9568084D510] PRIMARY KEY CLUSTERED ([ProcessId] ASC),
    CONSTRAINT [FK__ProcessType] FOREIGN KEY ([ProcessType]) REFERENCES [sprockit].[ProcessType] ([ProcessType]),
    CONSTRAINT [UQ__Process__BA37F0A392EBE9C2] UNIQUE NONCLUSTERED ([ProcessPath] ASC)
);









