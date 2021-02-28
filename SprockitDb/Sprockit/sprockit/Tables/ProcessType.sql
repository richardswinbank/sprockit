CREATE TABLE [sprockit].[ProcessType] (
    [ProcessType] NVARCHAR (10)  NOT NULL,
    [Description] NVARCHAR (255) NULL,
    [HasHandler]  BIT            CONSTRAINT [DF_ProcessType_HasHandler] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK__sprockit_ProcessType] PRIMARY KEY CLUSTERED ([ProcessType] ASC)
);



