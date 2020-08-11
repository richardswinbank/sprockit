CREATE TABLE [sprockit].[Batch] (
    [BatchId]       INT      IDENTITY (1, 1) NOT NULL,
    [ProcessGroup]  INT      NOT NULL,
    [StartDateTime] DATETIME CONSTRAINT [DF__Batch__StartDate__4242D080] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK__Batch__5D55CE5810DDD0E1] PRIMARY KEY CLUSTERED ([BatchId] ASC)
);

