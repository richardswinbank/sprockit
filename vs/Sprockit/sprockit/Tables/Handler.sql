CREATE TABLE [sprockit].[Handler] (
    [HandlerId]     INT            IDENTITY (1, 1) NOT NULL,
    [BatchId]       INT            NOT NULL,
    [ExternalId]    NVARCHAR (255) NULL,
    [StartDateTime] DATETIME       DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]   DATETIME       NULL,
    [Status]        NVARCHAR (20)  DEFAULT ('Running') NOT NULL,
    PRIMARY KEY CLUSTERED ([HandlerId] ASC),
    FOREIGN KEY ([BatchId]) REFERENCES [sprockit].[Batch] ([BatchId])
);



