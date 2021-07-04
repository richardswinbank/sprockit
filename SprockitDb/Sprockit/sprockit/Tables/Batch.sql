CREATE TABLE [sprockit].[Batch] (
    [BatchId]       INT      IDENTITY (1, 1) NOT NULL,
    [ProcessGroup]  INT      NOT NULL,
    ExternalManagerId NVARCHAR(1024) NULL,
    [CreatedDateTime] DATETIME CONSTRAINT [DF__sprockit_Batch__CreatedDateTime] DEFAULT (getutcdate()) NOT NULL,
    EndDateTime DATETIME NULL,
    CONSTRAINT [PK__sprockit_Batch] PRIMARY KEY CLUSTERED ([BatchId] ASC)
);

