CREATE TABLE [sprockit].[Execution] (
    [ExecutionId]         INT             IDENTITY (1, 1) NOT NULL,
    [ProcessId]           INT             NOT NULL,
    [HandlerId]           INT             NOT NULL,
    [ExecutionProperties] NVARCHAR (4000) DEFAULT ('{}') NOT NULL,
    [StartDateTime]       DATETIME        DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]         DATETIME        NULL,
    [ProcessType]         NVARCHAR (4)    NULL,
    [EndStatus]           NVARCHAR (20)   NULL,
    [AvgDuration]         INT             NULL,
    [BranchWeight]        INT             NULL,
    [IsEnabled]           BIT             NULL,
    [Priority]            TINYINT         NULL,
    PRIMARY KEY CLUSTERED ([ExecutionId] ASC)
);

