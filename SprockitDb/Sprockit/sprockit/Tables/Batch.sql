CREATE TABLE [sprockit].[Batch] (
    [BatchId]       INT      IDENTITY (1, 1) NOT NULL,
    [ProcessGroup]  INT      NOT NULL,
    [StartDateTime] DATETIME CONSTRAINT [DF__sprockit_Batch__StartDate] DEFAULT (getutcdate()) NOT NULL,
    [Status] NVARCHAR(20) CONSTRAINT [DF__sprockit_Batch__Status] DEFAULT 'Incomplete' NOT NULL,
    LastStatusUpdate DATETIME CONSTRAINT [DF__sprockit_Batch__LastStatusUpdate] DEFAULT (getutcdate()) NOT NULL,
    [NumberOfStarts] INT CONSTRAINT [DF__sprockit_Batch__NumberOfStarts] DEFAULT 0 NOT NULL,
    ExternalManagerId NVARCHAR(1024) NULL,
    EndDateTime DATETIME NULL,
    CONSTRAINT [PK__sprockit_Batch] PRIMARY KEY CLUSTERED ([BatchId] ASC)
);

