CREATE TABLE [sprockit].[Execution] (
    [ExecutionId]         INT                                  IDENTITY (1, 1) NOT NULL,
    [ProcessId]           INT                                  NOT NULL,
    [HandlerId]           INT                                  NOT NULL,
    [ExecutionProperties] XML(CONTENT [sprockit].[Properties]) CONSTRAINT [DF__Execution__Execu__06CD04F7] DEFAULT ('<Properties/>') NOT NULL,
    [StartDateTime]       DATETIME                             CONSTRAINT [DF__Execution__Start__07C12930] DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]         DATETIME                             NULL,
    [ProcessType]         NVARCHAR (10)                        NOT NULL,
    [EndStatus]           NVARCHAR (20)                        NULL,
    [AvgDuration]         INT                                  NULL,
    [BranchWeight]        INT                                  NULL,
    [IsEnabled]           BIT                                  NULL,
    [Priority]            TINYINT                              NULL,
    CONSTRAINT [PK__Executio__473088C5CC6B846E] PRIMARY KEY CLUSTERED ([ExecutionId] ASC),
    CONSTRAINT [FK__Execution__Handl__3C34F16F] FOREIGN KEY ([HandlerId]) REFERENCES [sprockit].[Handler] ([HandlerId]),
    CONSTRAINT [FK__Execution__Proce__3B40CD36] FOREIGN KEY ([ProcessId]) REFERENCES [sprockit].[Process] ([ProcessId])
);





