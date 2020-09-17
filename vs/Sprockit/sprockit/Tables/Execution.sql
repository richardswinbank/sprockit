CREATE TABLE [sprockit].[Execution] (
    [ExecutionId]         INT                                  IDENTITY (1, 1) NOT NULL,
    [ProcessId]           INT                                  NOT NULL,
    [HandlerId]           INT                                  NOT NULL,
    [ExecutionProperties] XML(CONTENT [sprockit].[Properties]) CONSTRAINT [DF__sprockit_Execution__ExecutionProperties] DEFAULT ('<Properties/>') NOT NULL,
    [StartDateTime]       DATETIME                             CONSTRAINT [DF__sprockit_Execution__StartDateTime] DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]         DATETIME                             NULL,
    [ProcessType]         NVARCHAR (10)                        NOT NULL,
    [EndStatus]           NVARCHAR (20)                        NULL,
    [AvgDuration]         INT                                  NULL,
    [BranchWeight]        INT                                  NULL,
    [IsEnabled]           BIT                                  NULL,
    [Priority]            TINYINT                              NULL,
    CONSTRAINT [PK__sprockit_Execution] PRIMARY KEY CLUSTERED ([ExecutionId] ASC),
    CONSTRAINT [FK__sprockit_Execution__HandlerId] FOREIGN KEY ([HandlerId]) REFERENCES [sprockit].[Handler] ([HandlerId]),
    CONSTRAINT [FK__sprockit_Execution__ProcessId] FOREIGN KEY ([ProcessId]) REFERENCES [sprockit].[Process] ([ProcessId])
);





